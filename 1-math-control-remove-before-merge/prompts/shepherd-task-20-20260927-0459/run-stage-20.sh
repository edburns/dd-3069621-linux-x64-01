#!/usr/bin/env bash
set -euo pipefail

REPO='edburns/dd-3069621-linux-x64-01'
PARENT_ISSUE=1
LOG_DIRECTORY='/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459'
ISSUE_BODY_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh'
CHILD_LINK_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh'
LEDGER="$LOG_DIRECTORY/creation-ledger.json"
RESULT="$LOG_DIRECTORY/stage-20-result.json"
operation='initialization'
failure_handled=false

atomic_write() {
  local path="$1" content="$2" temporary
  temporary="$(mktemp "${path}.tmp.XXXXXX")"
  printf '%s\n' "$content" >"$temporary"
  mv "$temporary" "$path"
}

update_ledger_flag() {
  local number="$1" field="$2" value="$3" updated
  updated="$(
    jq \
      --argjson number "$number" \
      --arg field "$field" \
      --argjson value "$value" \
      'map(if .number == $number then .[$field] = $value else . end)' \
      "$LEDGER"
  )" || return 1
  atomic_write "$LEDGER" "$updated"
}

reconcile_and_fail() {
  local exit_code="$1" error_message="$2" server_children updated result
  "$failure_handled" && exit "$exit_code"
  failure_handled=true
  set +e
  server_children="$(
    gh api "repos/$REPO/issues/$PARENT_ISSUE/sub_issues" --paginate --slurp |
      jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end'
  )"
  if [[ $? -eq 0 ]]; then
    updated="$(
      jq \
        --argjson children "$server_children" \
        'map(. as $entry | .linked = ([ $children[].id ] | index($entry.id) != null))' \
        "$LEDGER"
    )"
    [[ $? -ne 0 ]] || atomic_write "$LEDGER" "$updated"
  else
    error_message="$error_message; reconciliation query also failed"
  fi
  result="$(
    jq -n \
      --arg error "$operation: $error_message" \
      '{
        schemaVersion: 1,
        status: "failed",
        ledgerFile: "creation-ledger.json",
        operationError: $error
      }'
  )"
  atomic_write "$RESULT" "$result"
  printf 'Stage 20 failed during %s: %s\n' "$operation" "$error_message" >&2
  if jq -e 'length == 0' "$LEDGER" >/dev/null; then
    printf 'No issues were created; no cleanup is required.\n' >&2
  else
    jq -r '.[] | "issue #\(.number) | \(.title) | \(.url) | \(.bodyFile) | body_verified=\(.body_verified) | linked=\(.linked)"' "$LEDGER" >&2
    jq -r --arg repo "$REPO" '.[] | "gh issue delete \(.number) --repo \"\($repo)\" --yes"' "$LEDGER" >&2
    printf 'The operation did not complete and no automatic rollback was performed. Delete every issue in the ledger before invoking this skill again.\n' >&2
  fi
  exit "$exit_code"
}

trap 'status=$?; if [[ $status -ne 0 && "$failure_handled" == false ]]; then reconcile_and_fail "$status" "command exited with status $status"; fi' EXIT

create_verify_link() {
  local subsection="$1" title="$2" relative_body="$3"
  local body_file="$LOG_DIRECTORY/$relative_body" issue_json issue_id issue_number issue_url ledger_updated

  operation="creating issue for $subsection"
  issue_json="$(
    gh api "repos/$REPO/issues" \
      -X POST \
      -f title="$title" \
      -F "body=@$body_file" \
      --jq '{id,number,node_id,html_url,title}'
  )" || reconcile_and_fail $? "GitHub issue creation failed"
  issue_id="$(jq -er '.id' <<<"$issue_json")"
  issue_number="$(jq -er '.number' <<<"$issue_json")"
  issue_url="$(jq -er '.html_url' <<<"$issue_json")"

  operation="recording issue #$issue_number in the creation ledger"
  ledger_updated="$(
    jq \
      --arg implementationSubsection "$subsection" \
      --arg bodyFile "$relative_body" \
      --argjson id "$issue_id" \
      --argjson number "$issue_number" \
      --arg title "$title" \
      --arg url "$issue_url" \
      '. + [{
        implementationSubsection: $implementationSubsection,
        bodyFile: $bodyFile,
        id: $id,
        number: $number,
        title: $title,
        url: $url,
        body_verified: false,
        linked: false
      }]' \
      "$LEDGER"
  )"
  atomic_write "$LEDGER" "$ledger_updated"

  operation="verifying issue #$issue_number body"
  "$ISSUE_BODY_VERIFIER" \
    "$REPO" \
    "$issue_number" \
    "$body_file" \
    6 \
    5 \
    "$LOG_DIRECTORY/issue-$issue_number-body-verification-failure.json" \
    >"$LOG_DIRECTORY/issue-$issue_number-observed.json" ||
      reconcile_and_fail $? "persisted draft did not match the GitHub issue body"
  update_ledger_flag "$issue_number" body_verified true

  operation="linking issue #$issue_number to parent #$PARENT_ISSUE"
  local linked=false
  for attempt in 1 2 3; do
    if printf '{"sub_issue_id": %s}' "$issue_id" |
      gh api "repos/$REPO/issues/$PARENT_ISSUE/sub_issues" -X POST --input - >/dev/null; then
      linked=true
      break
    fi
    [[ "$attempt" -eq 3 ]] || sleep 2
  done
  "$linked" || reconcile_and_fail 1 "linking failed after 3 attempts"
  update_ledger_flag "$issue_number" linked true
  printf 'Created, verified, and linked issue #%s: %s\n' "$issue_number" "$title"
}

create_verify_link \
  '1. Implement Fibonacci with unit and isolated CLI coverage' \
  '1. Implement Fibonacci with unit and isolated CLI coverage' \
  'issue-bodies/01-1-implement-fibonacci-body.md'

create_verify_link \
  '2. Add factorial and operation dispatch' \
  '2. Add factorial and operation dispatch' \
  'issue-bodies/02-2-add-factorial-dispatch-body.md'

operation='capturing final parent-child snapshot'
gh api "repos/$REPO/issues/$PARENT_ISSUE/sub_issues" --paginate --slurp |
  jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end' \
    >"$LOG_DIRECTORY/final-children.json"

operation='verifying child linkage postconditions'
"$CHILD_LINK_VERIFIER" \
  "$LOG_DIRECTORY/pre-creation-children.json" \
  "$LOG_DIRECTORY/final-children.json" \
  "$LEDGER" \
  >"$LOG_DIRECTORY/child-link-verification.json"

operation='verifying final issue body, state, and assignment postconditions'
while IFS=$'\t' read -r issue_number relative_body; do
  observed="$(
    "$ISSUE_BODY_VERIFIER" \
      "$REPO" \
      "$issue_number" \
      "$LOG_DIRECTORY/$relative_body" \
      6 \
      5 \
      "$LOG_DIRECTORY/issue-$issue_number-final-body-verification-failure.json"
  )"
  jq -e '.state == "open" and (.assignees | type == "array" and length == 0)' \
    <<<"$observed" >/dev/null
done < <(jq -r '.[] | [.number, .bodyFile] | @tsv' "$LEDGER")

operation='recording successful stage result'
atomic_write "$RESULT" '{
  "schemaVersion": 1,
  "status": "complete",
  "ledgerFile": "creation-ledger.json",
  "operationError": null
}'

trap - EXIT
printf 'Stage 20 completed successfully.\n'
