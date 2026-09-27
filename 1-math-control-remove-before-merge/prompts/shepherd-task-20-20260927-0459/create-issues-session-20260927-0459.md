# Copilot CLI Session

> [!NOTE]
> - **Session ID:** `ae9f5ecb-20ef-4504-8a62-1ca76c4d0258`  
> - **Started:** 9/27/2026, 4:59:36 AM  
> - **Duration:** 2m 3s  
> - **Exported:** 9/27/2026, 5:01:39 AM  

---

<sub>3s</sub>

### User

Invoke skill `shepherd-task-20-create-issues-from-plan` with these inputs:

- CAMPAIGN_ID: 49734e38-1237-40d0-991d-7ea30616efce
- LESSON_PROPAGATION: off
- REPO: edburns/dd-3069621-linux-x64-01
- BASE_BRANCH: experiment/shepherd-control
- PARENT_ISSUE: 1
- PLAN_DIRECTORY: 1-math-control-remove-before-merge
- PLAN_FILE_NAME: math-tool-ignorance-reduction-plan.md
- QUESTIONS_SECTION: ## Ignorance reduction
- IMPLEMENTATION_SECTION: ## Implementation
- EXPECTED_TASK_COUNT: 2
- BASE_REMOTE: origin
- LOG_DIRECTORY: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459
- DRAFT_VALIDATOR: /home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh
- ISSUE_BODY_VERIFIER: /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh
- CHILD_LINK_VERIFIER: /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh

Fixture pagination response contract (mandatory):

- `gh api ... --paginate --slurp` returns a JSON array of page payloads, so a
  one-page response has the shape `[[{...}]]`, not `[{...}]`.
- Before indexing child issue fields such as `.id`, normalize the response to
  one flat issue array exactly once.
- In Bash, use:
  `jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end'`.
- In PowerShell, capture the `gh` output and `$LASTEXITCODE` first, then pass
  the complete JSON through the same `jq` normalization before
  `ConvertFrom-Json`.
- Use the normalized flat array for the pre-creation baseline, final child
  count/order checks, and failure reconciliation. Do not apply `add` a second
  time to an already-flat array.

---

<sub>5s</sub>

### `skill`

**shepherd-task-20-create-issues-from-plan**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "shepherd-task-20-create-issues-from-plan"
}
```

</details>

```
Skill "shepherd-task-20-create-issues-from-plan" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>9s</sub>

### Copilot

I’m validating the campaign manifest, branch, parent issue, repository issue-type support, and existing child baseline before drafting any GitHub mutations.

---

<sub>18s</sub>

### `bash`

**Validate invocation and capture child baseline**

$ set -euo pipefail
REPO='edburns/dd-3069621-linux-x64-01'; BASE_BRANCH='experiment/shepherd-control'; BASE_REMOTE='origin'; LOG='/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459'; DRAFT='/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh'; BODY='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh'; CHILD='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh'
[[ "$BASE_BRANCH" != main ]]
[[ "$LOG" = /* && -d "$LOG" && -w "$LOG" ]]
mkdir -p "$LOG/issue-bodies"
for f in "$DRAFT" "$BODY" "$CHILD"; do [[ "$f" = /* && -f "$f" && -x "$f" ]]; done
git show-ref --verify --quiet "refs/heads/$BASE_BRANCH" || git show-ref --verify --quiet "refs/remotes/$BASE_REMOTE/$BASE_BRANCH"
git remote get-url "$BASE_REMOTE"
printf 'default='; gh api "repos/$REPO" --jq '.default_branch'
printf 'repo='; gh api "repos/$REPO" --jq '{owner:.owner.login,owner_type:.owner.type}'
printf 'parent='; gh api "repos/$REPO/issues/1" --jq '{number,state,title,html_url}'
printf 'remote='; git remote get-url "$BASE_REMOTE"
OWNER_TYPE=$(gh api "repos/$REPO" --jq '.owner.type')
OWNER=$(gh api "repos/$REPO" --jq '.owner.login')
if [[ "$OWNER_TYPE" == Organization ]]; then gh api "orgs/$OWNER/issue-types" --jq '[.[] | select(.name == "Task" and .is_enabled == true)]'; elif [[ "$OWNER_TYPE" == User ]]; then printf '[]\n'; else echo "unrecognized owner type: $OWNER_TYPE" >&2; exit 1; fi
gh api "repos/$REPO/issues/1/sub_issues" --paginate --slurp | jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end' > "$LOG/pre-creation-children.json"
printf 'baseline_children='; jq '[.[] | {id,number,title}]' "$LOG/pre-creation-children.json"

<details>
<summary>8 lines</summary>

```
git@github.com:edburns/dd-3069621-linux-x64-01.git
default=main
repo={"owner":"edburns","owner_type":"User"}
parent={"html_url":"https://github.com/edburns/dd-3069621-linux-x64-01/issues/1","number":1,"state":"open","title":"[Campaign][off] shepherd-task simple-math control"}
remote=git@github.com:edburns/dd-3069621-linux-x64-01.git
[]
baseline_children=[]
<shellId: 0 completed with exit code 0>
```

</details>


---

<sub>18s</sub>

### `bash`

**Read campaign plan and manifest**

$ set -euo pipefail
REF='experiment/shepherd-control'; DIR='1-math-control-remove-before-merge'; LOG='/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459'
git show "$REF:$DIR/math-tool-ignorance-reduction-plan.md" > "$LOG/plan-source.md"
git show "$REF:$DIR/shepherd-campaign.json" > "$LOG/campaign-source.json"
git cat-file -e "$REF:$DIR/campaign-lessons.md"
printf '%s\n' '--- manifest ---'; jq . "$LOG/campaign-source.json"
printf '%s\n' '--- plan headings ---'; grep -n '^##\|^###' "$LOG/plan-source.md"
printf '%s\n' '--- plan ---'; cat "$LOG/plan-source.md"

<details>
<summary>64 lines</summary>

```
--- manifest ---
{
  "schemaVersion": 1,
  "campaignId": "49734e38-1237-40d0-991d-7ea30616efce",
  "campaignIssueNumber": 1,
  "campaignShortname": "math-control",
  "repository": "edburns/dd-3069621-linux-x64-01",
  "baseBranch": "experiment/shepherd-control",
  "lessonPropagation": "off",
  "campaignMetadataDirectory": "1-math-control-remove-before-merge",
  "lessonsFile": "campaign-lessons.md",
  "createdBy": {
    "shepherdTaskVersion": "1.0.5",
    "stageOutcomeProtocolVersion": 1
  },
  "createdAt": "2026-09-27T04:59:33Z"
}
--- plan headings ---
7:## Ignorance reduction
9:### Repository-owned validation
18:### Output and ordering contracts
29:## Implementation
31:### 1. Implement Fibonacci with unit and isolated CLI coverage
43:### 2. Add factorial and operation dispatch
--- plan ---
# PowerShell math-tool control campaign

Build the fixture in two cheap, serial tasks. The repository already contains
deterministic CI pinned to Pester 5.7.1. The acceptance command for every task
is `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. Task 2 starts only after task 1 is merged.

## Ignorance reduction

### Repository-owned validation

**Question:** What command and environment define acceptance?

**Resolution:** The committed canonical command is
`pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The baseline workflow
`.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester
5.7.1 and invokes that repository-owned runner. Do not replace or bypass it.

### Output and ordering contracts

**Question:** What externally observable behavior and dependency order are required?

**Resolution:** Direct CLI execution writes exactly one result line to stdout:
`Fibonacci(N) = value` or `Factorial(N) = value`. Functions return the
numeric value without incidental output. Inputs are non-negative integers.
Implementation is serial: task 2 depends on merged task 1. The implementation
and test files are repository-root `math-tool.ps1` and
`math-tool.Tests.ps1`.

## Implementation

### 1. Implement Fibonacci with unit and isolated CLI coverage

Create `math-tool.ps1` with parameter `N` and a pure `Get-Fibonacci`
function. Direct execution must print exactly `Fibonacci(N) = value`.
Create `math-tool.Tests.ps1` containing dot-sourced unit tests for the
function and isolated child-`pwsh` process tests for direct CLI behavior.
Cover N=0, N=1, and a small representative value. Keep changes limited to the
math tool and its tests.

Acceptance: `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero and the pinned pull-request CI
passes.

### 2. Add factorial and operation dispatch

After task 1 is merged, extend the same script with a pure `Get-Factorial`
function and an `Operation` parameter that dispatches between `fibonacci`
and `factorial` while retaining `N`. Preserve Fibonacci behavior. Cover
factorial edge cases 0 and 1 plus a small representative value. Keep the
interface and tests objective and small; the issue does not prescribe how to
extend the tests.

Acceptance: `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite
and the pinned pull-request CI passes.
<shellId: 1 completed with exit code 0>
```

</details>


---

<sub>18s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/01-1682-java-tool-ergonomics.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/01-1682-java-tool-ergonomics.md (lines 1-220)

<details>
<summary>15 lines</summary>

```
# Example 01: 1682-java-tool-ergonomics-prompts-remove-before-merge

Read `copilot-sdk/1682-java-tool-ergonomics-prompts-remove-before-merge/dd-3018003-ignorance-reduction-for-implementation-plan.md` (the plan) to get the context.

✅✅Pay very close attention to each **Resolution:** to the questions in `Phase 3 — Ignorance reduction: questions to answer before writing code`.

In this session, we are creating issues of type **Task** as children of Epic https://github.com/github/copilot-sdk/issues/1682 . These issues correspond to the sub-sections in `## Phase 4 — Implementation (the build order)`.

I want you to use `gh` to create issues as sub-issues of 1682.

- I will dispatch these issues by assigning them to an agent. Leave them unassigned for now.

- The description you put in the issues you create is the specification for the work the agent assigned to the issue must do. Therefore, you need to be very specific and targeted when writing the description.

- Set the type to **Task**.

- Each issue will be worked on and resolved in serial. You can assume:
  - All issues will operate in this topic branch of `upstream`: `edburns/1682-java-tool-ergonomics`.

  - The assignee agent has access to the topic branch and, most importantly, to the prompts in the directory `1682-java-tool-ergonomics-prompts-remove-before-merge`, which includes the plan. Therefore, you can instruct the agent to access the plan by reference, you don't need to reference it by value directly in the issue.

- The sub-sections of `## Phase 4 — Implementation (the build order)` have essential details for each corresponding **Task**.

- Instruct the agent to read the entire plan before working.

- Instruct the agent to carefully re-read the relevant sections of the plan. ❌❌You can't just say, "read the relevant sections of the plan". ✅✅In the description of the issue, list exactly what sections of the plan apply to this particular issue.
- Though the sub-sections of `## Phase 4 — Implementation (the build order)` have essential details for each corresponding **Task**, I want you to carefully consider if there are additional gating tests you can add so that as the agent proceeds from one task to the next, the likelihood of rework is reduced.
```

</details>


---

<sub>18s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/02-1810-java-tool-as-lambda.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/02-1810-java-tool-as-lambda.md (lines 1-220)

<details>
<summary>12 lines</summary>

```
# Example 02: 1810-java-tool-ergonomics-tool-as-lambda-remove-before-merge

Carefully read the plan `copilot-sdk/1810-java-tool-ergonomics-tool-as-lambda-remove-before-merge/1810-ignorance-reduction-for-implementation-plan.md`.

We have completed Phases 1 - 3. We are now on Phase 4.

For each sub item in Phase 4, file a child issue of Feature #1810.

Use `gh` to look at Epic #1682 and its child issues for the standard of verbosity and concreteness for issue descriptions.

The issue should be assignable to a coding agent and there must be sufficient detail in the description for the agent to proceed to completion.

Pull out the specific relevant content from Phase 3 as it applies to this current issue in Phase 4.

Tell the agent to take `edburns/1810-java-tool-ergonomics-tool-as-lambda` as the base branch. When I assign the issue to the coding agent, I will set this as the base branch.

Tell the agent to read `1810-java-tool-ergonomics-tool-as-lambda-remove-before-merge/1810-ignorance-reduction-for-implementation-plan.md`, which is present on the branch, for context.

Tell the agent which sub-item within Phase 4 they are solving.

Tell the agent that each issue will be assigned, resolved and merged to the base branch in the order in which they appear in the plan.

No work is to start until I assign each issue to the coding agent, in turn.
```

</details>


---

<sub>18s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/03-dd-3017826-java-real-estate-demo.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/03-dd-3017826-java-real-estate-demo.md (lines 1-220)

<details>
<summary>14 lines</summary>

```
# Example 03: dd-3017826-java-real-estate-demo-remove-before-merge

Read `dd-3017826-java-real-estate-demo-remove-before-merge\dd-3017826-java-real-estate-demo-ignorance-reduction-plan.md` (the plan) to get the context.

✅✅Pay very close attention to each **Resolution:** to the questions in `Phase 2 — Ignorance reduction: questions to answer before writing code`.

In this session, we are creating sub-issues as children of https://github.com/edburns/Build26-BRK206-your-agent-anywhere-multiclient-multidevice-with-github-copilot-sdk/issues/2 . These issues correspond to the sub-sections in `## Phase 3 — Implementation (build order)`.

I want you to use `gh` to create issues as sub-issues of #2.

- I will dispatch these issues by assigning them to an agent. Leave them unassigned for now.

- The description you put in the issues you create is the specification for the work the agent assigned to the issue must do. Therefore, you need to be very specific and targeted when writing the description.

- Each issue will be worked on and resolved in serial. You can assume:
  - All issues will operate in this topic branch of `origin`: `edburns/2-build-out-demo`.

  - The assignee agent has access to the topic branch and, most importantly, to the prompts in the directory `dd-3017826-java-real-estate-demo-remove-before-merge`, which includes the plan. Therefore, you can instruct the agent to access the plan by reference, you don't need to reference it by value directly in the issue.

- The sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue.

- Instruct the agent to read the entire plan before working.

- Instruct the agent to carefully re-read the relevant sections of the plan. ❌❌You can't just say, "read the relevant sections of the plan". ✅✅In the description of the issue, list exactly what sections of the plan apply to this particular issue.
- Though the sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue, I want you to carefully consider if there are additional gating tests you can add so that as the agent proceeds from one task to the next, the likelihood of rework is reduced.
```

</details>


---

<sub>18s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/04-28-python-agent-demo.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/04-28-python-agent-demo.md (lines 1-220)

<details>
<summary>16 lines</summary>

```
# Example 04: 28-python-agent-demo-remove-before-merge

Read `28-python-agent-demo-remove-before-merge/28-python-agent-demo-ignorance-reduction-plan.md` (the plan) to get the context.

✅✅Pay very close attention to each **Resolution:** to the questions in `Phase 2 — Ignorance reduction: questions to answer before writing code`. These pertain to the implementation tasks in Phase 3. ✅✅✅ Include relevant spike findings as self-contained prose in the issue description; do not direct the agent to spike directories or source files.

In this session, we are creating sub-issues as children of https://github.com/edburns/Build26-BRK206-your-agent-anywhere-multiclient-multidevice-with-github-copilot-sdk/issues/28 . These issues correspond to the sub-sections in `## Phase 3 — Implementation (build order)`.

I want you to use `gh` to create issues as sub-issues of #28

- I will dispatch these issues by assigning them to an agent. Leave them unassigned for now.

- The description you put in the issues you create is the specification for the work the agent assigned to the issue must do. Therefore, you need to be very specific and targeted when writing the description.

- Again, ✅✅For each **Resolution:** to the questions in `Phase 2 — Ignorance reduction: questions to answer before writing code`, include the relevant Resolution values in the issue description. These pertain to the implementation tasks in Phase 3. ✅✅✅ State relevant spike findings directly in the issue body with enough detail to implement them without reading spike code.

- For tasks dealing with the UI, make sure to refer to the relevant screengrabs, but only ones within `28-python-agent-demo-remove-before-merge/`.

- Each issue will be worked on and resolved in serial. You can assume:
  - All issues will operate in this topic branch of `origin`: `edburns/28-python-agent-demo`.

  - The assignee agent has access to the topic branch and, most importantly, to the prompts in the directory `28-python-agent-demo-remove-before-merge/`, which includes the plan. Therefore, you can instruct the agent to access the plan by reference, you don't need to reference it by value directly in the issue.

- The sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue.

- Instruct the agent to read the entire plan before working.

- Instruct the agent to carefully re-read the relevant sections of the plan. ❌❌You can't just say, "read the relevant sections of the plan". ✅✅In the description of the issue, list exactly what sections of the plan apply to this particular issue.
- Though the sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue, I want you to carefully consider if there are additional gating tests you can add so that as the agent proceeds from one task to the next, the likelihood of rework is reduced.
```

</details>


---

<sub>22s</sub>

### Copilot

Validation passed: the parent is open, the base branch differs from `main`, the manifest matches, both implementation decisions are concretely resolved, exactly two tasks exist, and this user-owned repository will create children **without an issue type**. I’m now checking the supporting-resource inventory and validator contracts, then I’ll persist and validate both complete issue specifications before creation.

---

<sub>23s</sub>

### `bash`

**List campaign supporting resources**

$ git ls-tree -r --name-only experiment/shepherd-control -- '1-math-control-remove-before-merge' | sed -n '1,200p'

```
1-math-control-remove-before-merge/campaign-lessons.md
1-math-control-remove-before-merge/math-tool-ignorance-reduction-plan.md
1-math-control-remove-before-merge/shepherd-campaign.json
1-math-control-remove-before-merge/shepherd-test-experiment.json
<shellId: 2 completed with exit code 0>
```


---

<sub>23s</sub>

### `view`

**view the file at /home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh.**

/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh (lines 1-260)

<details>
<summary>65 lines</summary>

```
#!/usr/bin/env bash
# shepherd-task-version: 1.0.5

set -euo pipefail

[[ $# -eq 3 ]] || {
    echo "Usage: $0 <body-directory> <expected-count> <off|campaign>" >&2
    exit 1
}

body_directory="$1"
expected_count="$2"
lesson_propagation="$3"

[[ -d "$body_directory" ]] || {
    echo "Stage-20 body directory does not exist: $body_directory" >&2
    exit 1
}
[[ "$expected_count" =~ ^[1-9][0-9]*$ ]] || {
    echo "Expected count must be a positive integer." >&2
    exit 1
}
[[ "$lesson_propagation" == "off" || "$lesson_propagation" == "campaign" ]] || {
    echo "Lesson propagation must be off or campaign." >&2
    exit 1
}

body_files=()
for body_file in "$body_directory"/*-body.md; do
    [[ -f "$body_file" ]] || continue
    [[ "$body_file" != *-observed-body.md ]] || continue
    body_files+=("$body_file")
done
[[ ${#body_files[@]} -eq $expected_count ]] || {
    echo "Expected $expected_count persisted stage-20 body files; found ${#body_files[@]}." >&2
    exit 1
}

required_headings=(
    '## Campaign context and required reading'
    '## Branch and execution order'
    '## Implement'
    '## Completion gates'
    '## Out of scope'
)

for body_file in "${body_files[@]}"; do
    [[ -s "$body_file" && "$(awk 'END { print NR }' "$body_file")" -gt 1 ]] || {
        echo "Persisted issue body must contain physical Markdown lines: $body_file" >&2
        exit 1
    }
    first_nonblank="$(awk 'NF { print; exit }' "$body_file")"
    [[ "$first_nonblank" =~ ^##[[:space:]]+[^[:space:]] ]] || {
        echo "Persisted issue body must begin with a level-two heading: $body_file" >&2
        exit 1
    }
    for heading in "${required_headings[@]}"; do
        grep -Fqx -- "$heading" "$body_file" || {
            echo "Persisted issue body is missing the physical heading '$heading': $body_file" >&2
            exit 1
        }
    done
    if [[ "$lesson_propagation" == "campaign" ]]; then
        grep -Fqx -- '## Campaign lessons (REQUIRED)' "$body_file" || {
            echo "Treatment issue body is missing its campaign-lessons heading: $body_file" >&2
            exit 1
        }
    elif grep -Fqx -- '## Campaign lessons (REQUIRED)' "$body_file"; then
        echo "Control issue body unexpectedly contains a campaign-lessons heading: $body_file" >&2
        exit 1
    fi
done
```

</details>


---

<sub>23s</sub>

### `view`

**view the file at /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh.**

/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh (lines 1-260)

<details>
<summary>131 lines</summary>

```
#!/usr/bin/env bash
# shepherd-task-version: 1.0.5
set -euo pipefail

fail() {
    printf 'verify-github-issue-body: %s\n' "$*" >&2
    exit 1
}

[[ $# -ge 3 && $# -le 6 ]] ||
    fail "usage: $0 OWNER/REPO ISSUE_NUMBER EXPECTED_BODY_PATH [MAX_ATTEMPTS] [DELAY_SECONDS] [DIAGNOSTIC_PATH]"

repository="$1"
issue_number="$2"
expected_body_path="$3"
max_attempts="${4:-6}"
delay_seconds="${5:-5}"
diagnostic_path="${6:-}"
gh_command="${GH_COMMAND:-gh}"

[[ "$repository" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] ||
    fail "invalid repository: $repository"
[[ "$issue_number" =~ ^[1-9][0-9]*$ ]] ||
    fail "invalid issue number: $issue_number"
[[ "$max_attempts" =~ ^[1-9][0-9]*$ ]] ||
    fail "MAX_ATTEMPTS must be a positive integer"
[[ "$delay_seconds" =~ ^[0-9]+$ ]] ||
    fail "DELAY_SECONDS must be a non-negative integer"
[[ -f "$expected_body_path" ]] ||
    fail "expected issue body file not found: $expected_body_path"

temp_directory="$(mktemp -d)"
trap 'rm -rf "$temp_directory"' EXIT
response_path="$temp_directory/response.json"
actual_path="$temp_directory/actual.txt"
actual_normalized="$temp_directory/actual-normalized.txt"
expected_normalized="$temp_directory/expected-normalized.txt"

normalize_file() {
    jq -b -Rsj 'gsub("\r\n|\r"; "\n")' "$1" >"$2"
}

equivalent_files() {
    local actual="$1"
    local expected="$2"
    local candidate="$temp_directory/candidate.txt"

    cmp -s -- "$actual" "$expected" && return 0
    cp "$actual" "$candidate"
    printf '\n' >>"$candidate"
    cmp -s -- "$candidate" "$expected" && return 0
    cp "$expected" "$candidate"
    printf '\n' >>"$candidate"
    cmp -s -- "$actual" "$candidate"
}

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    else
        shasum -a 256 "$1" | awk '{print $1}'
    fi
}

write_diagnostic() {
    local reason="$1"
    local attempts="$2"
    [[ -n "$diagnostic_path" ]] || return 0

    mkdir -p "$(dirname "$diagnostic_path")"
    local expected_length actual_length expected_hash actual_hash first_offset
    expected_length="$(wc -c <"$expected_normalized" | tr -d ' ')"
    actual_length="$(wc -c <"$actual_normalized" | tr -d ' ')"
    expected_hash="$(sha256_file "$expected_normalized")"
    actual_hash="$(sha256_file "$actual_normalized")"
    first_offset="$( (cmp -l -- "$actual_normalized" "$expected_normalized" 2>/dev/null || true) | awk 'NR == 1 { print $1 - 1 }')"
    [[ -n "$first_offset" ]] || first_offset="null"

    jq -n \
        --arg repository "$repository" \
        --argjson issueNumber "$issue_number" \
        --arg endpoint "repos/$repository/issues/$issue_number" \
        --argjson attempts "$attempts" \
        --arg observedAt "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --arg reason "$reason" \
        --argjson expectedLength "$expected_length" \
        --argjson actualLength "$actual_length" \
        --arg expectedSha256 "$expected_hash" \
        --arg actualSha256 "$actual_hash" \
        --argjson firstDifferenceOffset "$first_offset" \
        '{
            schemaVersion: 1,
            repository: $repository,
            issueNumber: $issueNumber,
            endpoint: $endpoint,
            attempts: $attempts,
            observedAt: $observedAt,
            reason: $reason,
            expectedLength: $expectedLength,
            actualLength: $actualLength,
            expectedSha256: $expectedSha256,
            actualSha256: $actualSha256,
            firstDifferenceOffset: $firstDifferenceOffset
        }' >"$diagnostic_path"
}

normalize_file "$expected_body_path" "$expected_normalized"
last_reason=""

for ((attempt = 1; attempt <= max_attempts; attempt++)); do
    set +e
    "$gh_command" api "repos/$repository/issues/$issue_number" >"$response_path" 2>"$temp_directory/error.txt"
    exit_code=$?
    set -e

    if [[ $exit_code -ne 0 ]]; then
        last_reason="GitHub REST request failed with exit code $exit_code."
        error_message="$(cat "$temp_directory/error.txt")"
        authentication_error_pattern='HTTP[[:space:]]+(401|403)|[Aa]uthentication|[Nn][Oo][Tt][[:space:]]authorized|[Rr]esource[[:space:]]not[[:space:]]accessible'
        if [[ "$error_message" =~ $authentication_error_pattern ]]; then
            : >"$actual_normalized"
            write_diagnostic "$last_reason" "$attempt"
            fail "unable to fetch issue #$issue_number from $repository: $error_message"
        fi
    elif ! jq -e 'type == "object" and has("body")' "$response_path" >/dev/null 2>&1; then
        last_reason="GitHub REST response was invalid JSON."
    else
        jq -b -j '.body // ""' "$response_path" >"$actual_path"
        normalize_file "$actual_path" "$actual_normalized"
        if equivalent_files "$actual_normalized" "$expected_normalized"; then
            cat "$response_path"
            exit 0
        fi
        last_reason="GitHub issue body differs from the persisted draft."
    fi

    if [[ $attempt -lt $max_attempts ]]; then
        printf 'verify-github-issue-body: %s Retrying issue #%s body verification (%s/%s).\n' \
            "$last_reason" "$issue_number" "$attempt" "$max_attempts" >&2
        ((delay_seconds > 0)) && sleep "$delay_seconds"
    fi
done

[[ -f "$actual_normalized" ]] || : >"$actual_normalized"
write_diagnostic "$last_reason" "$max_attempts"
diagnostic_suffix=""
[[ -z "$diagnostic_path" ]] || diagnostic_suffix=" Diagnostic: $diagnostic_path"
fail "issue #$issue_number body verification failed after $max_attempts attempts. $last_reason$diagnostic_suffix"
```

</details>


---

<sub>23s</sub>

### `view`

**view the file at /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh.**

/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh (lines 1-300)

<details>
<summary>30 lines</summary>

```
#!/usr/bin/env bash
# shepherd-task-version: 1.0.5

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <PRE_CREATION_CHILDREN_JSON> <FINAL_CHILDREN_JSON> <CREATION_LEDGER_JSON>" >&2
    exit 2
fi

for command_name in jq; do
    command -v "$command_name" >/dev/null 2>&1 || {
        echo "Error: Required command '$command_name' was not found." >&2
        exit 1
    }
done

script_dir="$(cd "$(dirname "$0")" && pwd)"
filter_path="$script_dir/verify-stage20-child-links.jq"
[[ -f "$filter_path" ]] || {
    echo "Error: Stage-20 child-link verification filter was not found: $filter_path" >&2
    exit 1
}

for input_path in "$@"; do
    [[ -f "$input_path" ]] || {
        echo "Error: Stage-20 child-link verification input was not found: $input_path" >&2
        exit 1
    }
done

jq -n \
    --slurpfile baseline "$1" \
    --slurpfile final "$2" \
    --slurpfile ledger "$3" \
    -f "$filter_path"
```

</details>


---

<sub>27s</sub>

### `bash`

**Read canonical math test runner**

$ git show experiment/shepherd-control:eng/test-math-tool.ps1

<details>
<summary>32 lines</summary>

```
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredVersion = '5.7.1'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$implementationPath = Join-Path $repositoryRoot 'math-tool.ps1'
$testPath = Join-Path $repositoryRoot 'math-tool.Tests.ps1'

$implementationExists = Test-Path -LiteralPath $implementationPath -PathType Leaf
$testsExist = Test-Path -LiteralPath $testPath -PathType Leaf
if (-not $implementationExists -and -not $testsExist) {
    Write-Host 'Math-tool implementation has not been introduced yet; baseline validation passed.'
    exit 0
}
if (-not $implementationExists -or -not $testsExist) {
    throw 'math-tool.ps1 and math-tool.Tests.ps1 must be introduced together.'
}

$available = Get-Module -ListAvailable Pester |
    Where-Object { $_.Version.ToString() -eq $requiredVersion } |
    Select-Object -First 1
if (-not $available) {
    Write-Host "Installing Pester $requiredVersion in CurrentUser scope..."
    Install-Module Pester -RequiredVersion $requiredVersion -Scope CurrentUser -Force
}

Import-Module Pester -RequiredVersion $requiredVersion -Force
$result = Invoke-Pester -Path $testPath -PassThru
if ($result.FailedCount -gt 0) {
    Write-Error "Pester reported $($result.FailedCount) failed test(s)."
    exit 1
}
exit 0
<shellId: 4 completed with exit code 0>
```

</details>


---

<sub>27s</sub>

### `bash`

**Read pinned math workflow**

$ git show experiment/shepherd-control:.github/workflows/shepherd-task-math-tool.yml

<details>
<summary>20 lines</summary>

```
name: Shepherd task math tool

on:
  pull_request:
  push:
  workflow_dispatch:

permissions:
  contents: read

jobs:
  test:
    name: Shepherd task math tool
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Pester 5.7.1
        shell: pwsh
        run: Install-Module Pester -RequiredVersion 5.7.1 -Scope CurrentUser -Force
      - name: Test math tool
        shell: pwsh
        run: ./eng/test-math-tool.ps1
<shellId: 6 completed with exit code 0>
```

</details>


---

<sub>27s</sub>

### `bash`

**Find existing math tool files**

$ git ls-tree -r --name-only experiment/shepherd-control | grep -E '(^|/)(math-tool|.*[Mm]ath).*' || true

<details>
<summary>7 lines</summary>

```
.github/workflows/shepherd-task-math-tool.yml
1-math-control-remove-before-merge/campaign-lessons.md
1-math-control-remove-before-merge/math-tool-ignorance-reduction-plan.md
1-math-control-remove-before-merge/shepherd-campaign.json
1-math-control-remove-before-merge/shepherd-test-experiment.json
eng/test-math-tool.ps1
<shellId: 3 completed with exit code 0>
```

</details>


---

<sub>27s</sub>

### `bash`

**Read campaign experiment metadata**

$ git show experiment/shepherd-control:1-math-control-remove-before-merge/shepherd-test-experiment.json | jq .

<details>
<summary>7 lines</summary>

```
{
  "schemaVersion": 1,
  "baselineSha": "8a3399b8e3ac68f2bdb5a202946dfbcd92ab81f4",
  "lessonPropagation": "off",
  "expectedTaskCount": 2
}
<shellId: 5 completed with exit code 0>
```

</details>


---

<sub>54s</sub>

### `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Add File: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/issue-bodies/01-1-implement-fibonacci-body.md\n+## Campaign context and required reading\n+\n+**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**\n+\n+Read the entire plan before working. Then carefully re-read these exact sections:\n+\n+- `## Ignorance reduction`\n+- `### Repository-owned validation`\n+- `### Output and ordering contracts`\n+- `## Implementation`\n+- `### 1. Implement Fibonacci with unit and isolated CLI coverage`\n+\n+Apply these resolved decisions:\n+\n+- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The committed workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.\n+- Direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`.\n+- Functions return only their numeric value, with no incidental output.\n+- Inputs are non-negative integers.\n+- The implementation and test files are the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.\n+\n+Research for this campaign established that function behavior and direct-process CLI behavior must be tested separately. Dot-sourcing is the unit-test boundary, while a child `pwsh` process is the isolation boundary for proving exact stdout. Implement production code and production tests from the specification rather than copying research artifacts.\n+\n+## Branch and execution order\n+\n+Use `experiment/shepherd-control` as the PR base branch. This is implementation task 1 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned. Task 2 must not start until this task is merged into the base branch.\n+\n+## Implement\n+\n+Create `math-tool.ps1` with:\n+\n+- A parameter named `N` accepting non-negative integer input.\n+- A pure `Get-Fibonacci` function that returns the numeric Fibonacci value without writing incidental output.\n+- Direct script execution that calls the function and writes exactly one result line: `Fibonacci(N) = value`.\n+- Correct Fibonacci results for the edge cases `N=0` and `N=1` and for representative larger non-negative values.\n+\n+Create `math-tool.Tests.ps1` in the repository root with:\n+\n+- Dot-sourced unit coverage of `Get-Fibonacci`, including `N=0`, `N=1`, and at least one small representative value.\n+- Isolated child-`pwsh` process coverage of direct CLI execution. Assert successful exit and exact stdout for the same boundary and representative inputs so function output cannot mask script-level formatting or incidental output.\n+- Tests compatible with Pester 5.7.1 and the existing `eng/test-math-tool.ps1` runner.\n+\n+Keep the implementation straightforward and deterministic. Preserve a clean separation between the pure function's numeric return value and the script entry point's single formatted output line.\n+\n+## Completion gates\n+\n+- `math-tool.ps1` and `math-tool.Tests.ps1` are introduced together, as required by the repository-owned runner.\n+- Dot-sourced tests prove `Get-Fibonacci 0` returns `0`, `Get-Fibonacci 1` returns `1`, and a representative value is correct with no incidental output.\n+- Child-process tests prove direct invocation exits zero and stdout contains exactly one line in the required `Fibonacci(N) = value` format for edge and representative inputs.\n+- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero.\n+- The pinned pull-request workflow passes with Pester 5.7.1.\n+- The PR targets `experiment/shepherd-control` and contains only changes needed for this task.\n+\n+## Out of scope\n+\n+- Do not implement factorial, operation dispatch, or task 2 behavior.\n+- Do not change the canonical runner, the pinned Pester version, or the workflow to make tests pass.\n+- Do not add unrelated operations, output formats, dependencies, or repository changes.\n+- Do not read, copy, adapt, or promote spike source code; implement from the resolved findings above.\n*** Add File: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/issue-bodies/02-2-add-factorial-dispatch-body.md\n+## Campaign context and required reading\n+\n+**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**\n+\n+Read the entire plan before working. Then carefully re-read these exact sections:\n+\n+- `## Ignorance reduction`\n+- `### Repository-owned validation`\n+- `### Output and ordering contracts`\n+- `## Implementation`\n+- `### 1. Implement Fibonacci with unit and isolated CLI coverage`\n+- `### 2. Add factorial and operation dispatch`\n+\n+Apply these resolved decisions:\n+\n+- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The committed workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.\n+- Direct CLI execution writes exactly one result line to stdout: `Fibonacci(N) = value` or `Factorial(N) = value`, according to the selected operation.\n+- Functions return only their numeric value, with no incidental output.\n+- Inputs are non-negative integers.\n+- This task starts only after task 1 has merged and must preserve all merged Fibonacci behavior.\n+- The implementation and test files remain the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.\n+\n+Research for this campaign established that pure function behavior and direct-process dispatch/output behavior need distinct coverage. Dot-sourcing verifies numeric return contracts, while isolated child `pwsh` processes verify dispatch and exact stdout without contamination from the test process. Implement production code and production tests from these findings rather than copying research artifacts.\n+\n+## Branch and execution order\n+\n+Use `experiment/shepherd-control` as the PR base branch. This is implementation task 2 of 2 and depends on task 1 already being merged into that branch. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned and task 1 is present on the base branch.\n+\n+## Implement\n+\n+Extend the merged `math-tool.ps1` with:\n+\n+- A pure `Get-Factorial` function that returns the numeric factorial value without writing incidental output.\n+- An `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining the existing `N` parameter.\n+- Preservation of the task 1 Fibonacci function and direct-invocation behavior. Existing Fibonacci invocations must remain valid; selecting Fibonacci must write exactly `Fibonacci(N) = value`.\n+- Factorial direct execution that writes exactly `Factorial(N) = value`.\n+- Correct factorial results for `N=0`, `N=1`, and at least one small representative value.\n+\n+Extend `math-tool.Tests.ps1` with focused coverage that:\n+\n+- Dot-sources the script and verifies `Get-Factorial` returns numeric results for `0`, `1`, and a representative value without incidental output.\n+- Runs the script in isolated child `pwsh` processes to prove the operation parameter selects the correct implementation and produces exactly one correctly labeled result line.\n+- Retains the complete Fibonacci unit and CLI regression suite from task 1.\n+- Remains compatible with Pester 5.7.1 and the existing `eng/test-math-tool.ps1` runner.\n+\n+Keep the public interface objective and small. Use the established PowerShell behavior needed to preserve task 1's existing Fibonacci invocation while adding explicit factorial selection; do not broaden the operation set.\n+\n+## Completion gates\n+\n+- Factorial unit tests prove `0! = 1`, `1! = 1`, and at least one representative value is correct, with numeric-only function output.\n+- Isolated CLI tests prove both operation paths exit zero and emit exactly one line with the required operation-specific label and value.\n+- A discriminating dispatch test invokes both operations with the same `N` where their results differ, preventing an implementation that ignores `Operation` from passing.\n+- All task 1 Fibonacci unit and isolated CLI tests continue to pass unchanged in behavioral intent.\n+- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite.\n+- The pinned pull-request workflow passes with Pester 5.7.1.\n+- The PR targets `experiment/shepherd-control` and contains only changes needed for this task.\n+\n+## Out of scope\n+\n+- Do not add operations beyond Fibonacci and factorial.\n+- Do not redesign unrelated repository code or introduce unnecessary dependencies.\n+- Do not change the canonical runner, the pinned Pester version, or the workflow to make tests pass.\n+- Do not weaken, remove, or bypass task 1's Fibonacci behavior or tests.\n+- Do not read, copy, adapt, or promote spike source code; implement from the resolved findings above.\n*** Add File: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/creation-ledger.json\n+[]\n*** Add File: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/stage-20-result.json\n+{\n+  \"schemaVersion\": 1,\n+  \"status\": \"in_progress\",\n+  \"ledgerFile\": \"creation-ledger.json\",\n+  \"operationError\": null\n+}\n*** End Patch\n"
```

</details>

```
Added 4 file(s): /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/issue-bodies/01-1-implement-fibonacci-body.md, /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/issue-bodies/02-2-add-factorial-dispatch-body.md, /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/creation-ledger.json, /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/stage-20-result.json
```


---

<sub>1m 6s</sub>

### `bash`

**Validate persisted issue drafts**

$ set -euo pipefail
LOG='/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459'
'/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh' "$LOG/issue-bodies" 2 off
for body in "$LOG"/issue-bodies/*-body.md; do
  printf '%s: lines=%s bytes=%s first=%s\n' "$(basename "$body")" "$(wc -l < "$body")" "$(wc -c < "$body")" "$(awk 'NF {print; exit}' "$body")"
done
jq -e 'type == "array" and length == 0' "$LOG/creation-ledger.json" >/dev/null
jq -e '.schemaVersion == 1 and .status == "in_progress" and .ledgerFile == "creation-ledger.json" and .operationError == null' "$LOG/stage-20-result.json" >/dev/null

```
01-1-implement-fibonacci-body.md: lines=58 bytes=4156 first=## Campaign context and required reading
02-2-add-factorial-dispatch-body.md: lines=64 bytes=4914 first=## Campaign context and required reading
<shellId: 7 completed with exit code 0>
```


---

<sub>1m 24s</sub>

### Copilot

Both persisted specifications passed the supplied draft validator and were re-read as multi-line Markdown. I’m starting the one-shot create → exact-body verify → link sequence in plan order, with an on-disk ledger updated after each operation and read-only reconciliation on any failure.

---

<sub>1m 29s</sub>

### `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Add File: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/run-stage-20.sh\n+#!/usr/bin/env bash\n+set -euo pipefail\n+\n+REPO='edburns/dd-3069621-linux-x64-01'\n+PARENT_ISSUE=1\n+LOG_DIRECTORY='/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459'\n+ISSUE_BODY_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh'\n+CHILD_LINK_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh'\n+LEDGER=\"$LOG_DIRECTORY/creation-ledger.json\"\n+RESULT=\"$LOG_DIRECTORY/stage-20-result.json\"\n+operation='initialization'\n+failure_handled=false\n+\n+atomic_write() {\n+  local path=\"$1\" content=\"$2\" temporary\n+  temporary=\"$(mktemp \"${path}.tmp.XXXXXX\")\"\n+  printf '%s\\n' \"$content\" >\"$temporary\"\n+  mv \"$temporary\" \"$path\"\n+}\n+\n+update_ledger_flag() {\n+  local number=\"$1\" field=\"$2\" value=\"$3\" updated\n+  updated=\"$(\n+    jq \\\n+      --argjson number \"$number\" \\\n+      --arg field \"$field\" \\\n+      --argjson value \"$value\" \\\n+      'map(if .number == $number then .[$field] = $value else . end)' \\\n+      \"$LEDGER\"\n+  )\" || return 1\n+  atomic_write \"$LEDGER\" \"$updated\"\n+}\n+\n+reconcile_and_fail() {\n+  local exit_code=\"$1\" error_message=\"$2\" server_children updated result\n+  \"$failure_handled\" && exit \"$exit_code\"\n+  failure_handled=true\n+  set +e\n+  server_children=\"$(\n+    gh api \"repos/$REPO/issues/$PARENT_ISSUE/sub_issues\" --paginate --slurp |\n+      jq 'if length == 0 then [] elif all(.[]; type == \"array\") then add else . end'\n+  )\"\n+  if [[ $? -eq 0 ]]; then\n+    updated=\"$(\n+      jq \\\n+        --argjson children \"$server_children\" \\\n+        'map(.linked = ([ $children[].id ] | index(.id) != null))' \\\n+        \"$LEDGER\"\n+    )\"\n+    [[ $? -ne 0 ]] || atomic_write \"$LEDGER\" \"$updated\"\n+  else\n+    error_message=\"$error_message; reconciliation query also failed\"\n+  fi\n+  result=\"$(\n+    jq -n \\\n+      --arg error \"$operation: $error_message\" \\\n+      '{\n+        schemaVersion: 1,\n+        status: \"failed\",\n+        ledgerFile: \"creation-ledger.json\",\n+        operationError: $error\n+      }'\n+  )\"\n+  atomic_write \"$RESULT\" \"$result\"\n+  printf 'Stage 20 failed during %s: %s\\n' \"$operation\" \"$error_message\" >&2\n+  if jq -e 'length == 0' \"$LEDGER\" >/dev/null; then\n+    printf 'No issues were created; no cleanup is required.\\n' >&2\n+  else\n+    jq -r '.[] | \"issue #\\(.number) | \\(.title) | \\(.url) | \\(.bodyFile) | body_verified=\\(.body_verified) | linked=\\(.linked)\"' \"$LEDGER\" >&2\n+    jq -r --arg repo \"$REPO\" '.[] | \"gh issue delete \\(.number) --repo \\\"\\($repo)\\\" --yes\"' \"$LEDGER\" >&2\n+    printf 'The operation did not complete and no automatic rollback was performed. Delete every issue in the ledger before invoking this skill again.\\n' >&2\n+  fi\n+  exit \"$exit_code\"\n+}\n+\n+trap 'status=$?; if [[ $status -ne 0 && \"$failure_handled\" == false ]]; then reconcile_and_fail \"$status\" \"command exited with status $status\"; fi' EXIT\n+\n+create_verify_link() {\n+  local subsection=\"$1\" title=\"$2\" relative_body=\"$3\"\n+  local body_file=\"$LOG_DIRECTORY/$relative_body\" issue_json issue_id issue_number issue_url ledger_updated\n+\n+  operation=\"creating issue for $subsection\"\n+  issue_json=\"$(\n+    gh api \"repos/$REPO/issues\" \\\n+      -X POST \\\n+      -f title=\"$title\" \\\n+      -F \"body=@$body_file\" \\\n+      --jq '{id,number,node_id,html_url,title}'\n+  )\" || reconcile_and_fail $? \"GitHub issue creation failed\"\n+  issue_id=\"$(jq -er '.id' <<<\"$issue_json\")\"\n+  issue_number=\"$(jq -er '.number' <<<\"$issue_json\")\"\n+  issue_url=\"$(jq -er '.html_url' <<<\"$issue_json\")\"\n+\n+  operation=\"recording issue #$issue_number in the creation ledger\"\n+  ledger_updated=\"$(\n+    jq \\\n+      --arg implementationSubsection \"$subsection\" \\\n+      --arg bodyFile \"$relative_body\" \\\n+      --argjson id \"$issue_id\" \\\n+      --argjson number \"$issue_number\" \\\n+      --arg title \"$title\" \\\n+      --arg url \"$issue_url\" \\\n+      '. + [{\n+        implementationSubsection: $implementationSubsection,\n+        bodyFile: $bodyFile,\n+        id: $id,\n+        number: $number,\n+        title: $title,\n+        url: $url,\n+        body_verified: false,\n+        linked: false\n+      }]' \\\n+      \"$LEDGER\"\n+  )\"\n+  atomic_write \"$LEDGER\" \"$ledger_updated\"\n+\n+  operation=\"verifying issue #$issue_number body\"\n+  \"$ISSUE_BODY_VERIFIER\" \\\n+    \"$REPO\" \\\n+    \"$issue_number\" \\\n+    \"$body_file\" \\\n+    6 \\\n+    5 \\\n+    \"$LOG_DIRECTORY/issue-$issue_number-body-verification-failure.json\" \\\n+    >\"$LOG_DIRECTORY/issue-$issue_number-observed.json\" ||\n+      reconcile_and_fail $? \"persisted draft did not match the GitHub issue body\"\n+  update_ledger_flag \"$issue_number\" body_verified true\n+\n+  operation=\"linking issue #$issue_number to parent #$PARENT_ISSUE\"\n+  local linked=false\n+  for attempt in 1 2 3; do\n+    if printf '{\"sub_issue_id\": %s}' \"$issue_id\" |\n+      gh api \"repos/$REPO/issues/$PARENT_ISSUE/sub_issues\" -X POST --input - >/dev/null; then\n+      linked=true\n+      break\n+    fi\n+    [[ \"$attempt\" -eq 3 ]] || sleep 2\n+  done\n+  \"$linked\" || reconcile_and_fail 1 \"linking failed after 3 attempts\"\n+  update_ledger_flag \"$issue_number\" linked true\n+  printf 'Created, verified, and linked issue #%s: %s\\n' \"$issue_number\" \"$title\"\n+}\n+\n+create_verify_link \\\n+  '1. Implement Fibonacci with unit and isolated CLI coverage' \\\n+  '1. Implement Fibonacci with unit and isolated CLI coverage' \\\n+  'issue-bodies/01-1-implement-fibonacci-body.md'\n+\n+create_verify_link \\\n+  '2. Add factorial and operation dispatch' \\\n+  '2. Add factorial and operation dispatch' \\\n+  'issue-bodies/02-2-add-factorial-dispatch-body.md'\n+\n+operation='capturing final parent-child snapshot'\n+gh api \"repos/$REPO/issues/$PARENT_ISSUE/sub_issues\" --paginate --slurp |\n+  jq 'if length == 0 then [] elif all(.[]; type == \"array\") then add else . end' \\\n+    >\"$LOG_DIRECTORY/final-children.json\"\n+\n+operation='verifying child linkage postconditions'\n+\"$CHILD_LINK_VERIFIER\" \\\n+  \"$LOG_DIRECTORY/pre-creation-children.json\" \\\n+  \"$LOG_DIRECTORY/final-children.json\" \\\n+  \"$LEDGER\" \\\n+  >\"$LOG_DIRECTORY/child-link-verification.json\"\n+\n+operation='verifying final issue body, state, and assignment postconditions'\n+while IFS=$'\\t' read -r issue_number relative_body; do\n+  observed=\"$(\n+    \"$ISSUE_BODY_VERIFIER\" \\\n+      \"$REPO\" \\\n+      \"$issue_number\" \\\n+      \"$LOG_DIRECTORY/$relative_body\" \\\n+      6 \\\n+      5 \\\n+      \"$LOG_DIRECTORY/issue-$issue_number-final-body-verification-failure.json\"\n+  )\"\n+  jq -e '.state == \"open\" and (.assignees | type == \"array\" and length == 0)' \\\n+    <<<\"$observed\" >/dev/null\n+done < <(jq -r '.[] | [.number, .bodyFile] | @tsv' \"$LEDGER\")\n+\n+operation='recording successful stage result'\n+atomic_write \"$RESULT\" '{\n+  \"schemaVersion\": 1,\n+  \"status\": \"complete\",\n+  \"ledgerFile\": \"creation-ledger.json\",\n+  \"operationError\": null\n+}'\n+\n+trap - EXIT\n+printf 'Stage 20 completed successfully.\\n'\n*** End Patch\n"
```

</details>

```
Added 1 file(s): /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/run-stage-20.sh
```


---

<sub>1m 35s</sub>

### `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Update File: /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/run-stage-20.sh\n@@\n     updated=\"$(\n       jq \\\n         --argjson children \"$server_children\" \\\n-        'map(.linked = ([ $children[].id ] | index(.id) != null))' \\\n+        'map(. as $entry | .linked = ([ $children[].id ] | index($entry.id) != null))' \\\n         \"$LEDGER\"\n     )\"\n*** End Patch\n"
```

</details>

```
Modified 1 file(s): /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/run-stage-20.sh
```


---

<sub>1m 46s</sub>

### `bash`

**Create verify and link child issues**

$ bash '/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/run-stage-20.sh'

```
Created, verified, and linked issue #2: 1. Implement Fibonacci with unit and isolated CLI coverage
Created, verified, and linked issue #3: 2. Add factorial and operation dispatch
Stage 20 completed successfully.
<shellId: 8 completed with exit code 0>
```


---

<sub>1m 54s</sub>

### Copilot

Creation and linkage succeeded for #2 and #3. I’m reading the authoritative result, ledger, and child-link verifier output once more to produce the ordered stage-25 handoff from persisted state rather than transient command output.

---

<sub>1m 57s</sub>

### `view`

**view the file at /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/creation-ledger.json.**

/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/creation-ledger.json

<details>
<summary>22 lines</summary>

```
[
  {
    "implementationSubsection": "1. Implement Fibonacci with unit and isolated CLI coverage",
    "bodyFile": "issue-bodies/01-1-implement-fibonacci-body.md",
    "id": 5599872062,
    "number": 2,
    "title": "1. Implement Fibonacci with unit and isolated CLI coverage",
    "url": "https://github.com/edburns/dd-3069621-linux-x64-01/issues/2",
    "body_verified": true,
    "linked": true
  },
  {
    "implementationSubsection": "2. Add factorial and operation dispatch",
    "bodyFile": "issue-bodies/02-2-add-factorial-dispatch-body.md",
    "id": 5599872183,
    "number": 3,
    "title": "2. Add factorial and operation dispatch",
    "url": "https://github.com/edburns/dd-3069621-linux-x64-01/issues/3",
    "body_verified": true,
    "linked": true
  }
]
```

</details>


---

<sub>1m 57s</sub>

### `view`

**view the file at /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/stage-20-result.json.**

/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/stage-20-result.json

<details>
<summary>6 lines</summary>

```
{
  "schemaVersion": 1,
  "status": "complete",
  "ledgerFile": "creation-ledger.json",
  "operationError": null
}
```

</details>


---

<sub>1m 57s</sub>

### `view`

**view the file at /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/child-link-verification.json.**

/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/child-link-verification.json

<details>
<summary>9 lines</summary>

```
{
  "baselineCount": 0,
  "ledgerCount": 2,
  "finalCount": 2,
  "newIssueIds": [
    5599872062,
    5599872183
  ]
}
```

</details>


---

<sub>1m 57s</sub>

### `view`

**view the file at /home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/final-children.json.**

/home/edburns/workareas/dd-3069621-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260927-0459/final-children.json (lines 1-180)

<details>
<summary>180 lines</summary>

```
[
  {
    "url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/2",
    "repository_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01",
    "labels_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/2/labels{/name}",
    "comments_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/2/comments",
    "events_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/2/events",
    "html_url": "https://github.com/edburns/dd-3069621-linux-x64-01/issues/2",
    "id": 5599872062,
    "node_id": "I_kwDOUtuZ1c8AAAABTcdEPg",
    "number": 2,
    "title": "1. Implement Fibonacci with unit and isolated CLI coverage",
    "user": {
      "login": "edburns",
      "id": 75821,
      "node_id": "MDQ6VXNlcjc1ODIx",
      "avatar_url": "https://avatars.githubusercontent.com/u/75821?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/edburns",
      "html_url": "https://github.com/edburns",
      "followers_url": "https://api.github.com/users/edburns/followers",
      "following_url": "https://api.github.com/users/edburns/following{/other_user}",
      "gists_url": "https://api.github.com/users/edburns/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/edburns/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/edburns/subscriptions",
      "organizations_url": "https://api.github.com/users/edburns/orgs",
      "repos_url": "https://api.github.com/users/edburns/repos",
      "events_url": "https://api.github.com/users/edburns/events{/privacy}",
      "received_events_url": "https://api.github.com/users/edburns/received_events",
      "type": "User",
      "user_view_type": "public",
      "site_admin": true
    },
    "labels": [],
    "state": "open",
    "locked": false,
    "assignees": [],
    "milestone": null,
    "comments": 0,
    "created_at": "2026-09-27T05:01:18Z",
    "updated_at": "2026-09-27T05:01:18Z",
    "closed_at": null,
    "assignee": null,
    "author_association": "OWNER",
    "issue_field_values": [],
    "type": null,
    "active_lock_reason": null,
    "sub_issues_summary": {
      "total": 0,
      "completed": 0,
      "percent_completed": 0
    },
    "parent_issue_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/1",
    "issue_dependencies_summary": {
      "blocked_by": 0,
      "total_blocked_by": 0,
      "blocking": 0,
      "total_blocking": 0
    },
    "repository": {
      "id": 1390123477,
      "node_id": "R_kgDOUtuZ1Q",
      "name": "dd-3069621-linux-x64-01",
      "full_name": "edburns/dd-3069621-linux-x64-01",
      "private": false,
      "owner": {
        "login": "edburns",
        "id": 75821,
        "node_id": "MDQ6VXNlcjc1ODIx",
        "avatar_url": "https://avatars.githubusercontent.com/u/75821?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/edburns",
        "html_url": "https://github.com/edburns",
        "followers_url": "https://api.github.com/users/edburns/followers",
        "following_url": "https://api.github.com/users/edburns/following{/other_user}",
        "gists_url": "https://api.github.com/users/edburns/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/edburns/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/edburns/subscriptions",
        "organizations_url": "https://api.github.com/users/edburns/orgs",
        "repos_url": "https://api.github.com/users/edburns/repos",
        "events_url": "https://api.github.com/users/edburns/events{/privacy}",
        "received_events_url": "https://api.github.com/users/edburns/received_events",
        "type": "User",
        "user_view_type": "public",
        "site_admin": true
      },
      "html_url": "https://github.com/edburns/dd-3069621-linux-x64-01",
      "description": "https://devdiv.visualstudio.com/DevDiv/_workitems/edit/3069621",
      "fork": false,
      "url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01",
      "forks_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/forks",
      "keys_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/keys{/key_id}",
      "collaborators_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/collaborators{/collaborator}",
      "teams_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/teams",
      "hooks_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/hooks",
      "issue_events_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/events{/number}",
      "events_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/events",
      "assignees_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/assignees{/user}",
      "branches_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/branches{/branch}",
      "tags_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/tags",
      "blobs_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/git/blobs{/sha}",
      "git_tags_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/git/tags{/sha}",
      "git_refs_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/git/refs{/sha}",
      "trees_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/git/trees{/sha}",
      "statuses_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/statuses/{sha}",
      "languages_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/languages",
      "stargazers_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/stargazers",
      "contributors_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/contributors",
      "subscribers_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/subscribers",
      "subscription_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/subscription",
      "commits_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/commits{/sha}",
      "git_commits_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/git/commits{/sha}",
      "comments_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/comments{/number}",
      "issue_comment_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/comments{/number}",
      "contents_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/contents/{+path}",
      "compare_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/compare/{base}...{head}",
      "merges_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/merges",
      "archive_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/{archive_format}{/ref}",
      "downloads_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/downloads",
      "issues_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues{/number}",
      "pulls_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/pulls{/number}",
      "milestones_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/milestones{/number}",
      "notifications_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/notifications{?since,all,participating}",
      "labels_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/labels{/name}",
      "releases_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/releases{/id}",
      "deployments_url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/deployments",
      "created_at": "2026-09-27T04:39:13Z",
      "updated_at": "2026-09-27T04:39:17Z",
      "pushed_at": "2026-09-27T04:59:34Z",
      "git_url": "git://github.com/edburns/dd-3069621-linux-x64-01.git",
      "ssh_url": "git@github.com:edburns/dd-3069621-linux-x64-01.git",
      "clone_url": "https://github.com/edburns/dd-3069621-linux-x64-01.git",
      "svn_url": "https://github.com/edburns/dd-3069621-linux-x64-01",
      "homepage": null,
      "size": 0,
      "stargazers_count": 0,
      "watchers_count": 0,
      "language": null,
      "has_issues": true,
      "has_projects": true,
      "has_downloads": false,
      "has_wiki": true,
      "has_pages": false,
      "has_discussions": false,
      "forks_count": 0,
      "mirror_url": null,
      "archived": false,
      "disabled": false,
      "open_issues_count": 3,
      "license": {
        "key": "mit",
        "name": "MIT License",
        "spdx_id": "MIT",
        "url": "https://api.github.com/licenses/mit",
        "node_id": "MDc6TGljZW5zZTEz"
      },
      "allow_forking": true,
      "is_template": false,
      "web_commit_signoff_required": false,
      "has_pull_requests": true,
      "pull_request_creation_policy": "all",
      "topics": [],
      "visibility": "public",
      "forks": 0,
      "open_issues": 3,
      "watchers": 0,
      "default_branch": "main",
      "permissions": {
        "admin": true,
        "maintain": true,
        "push": true,
        "triage": true,
        "pull": true
      }
    },
    "body": "## Campaign context and required reading\n\n**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**\n\nRead the entire plan before working. Then carefully re-read these exact sections:\n\n- `## Ignorance reduction`\n- `### Repository-owned validation`\n- `### Output and ordering contracts`\n- `## Implementation`\n- `### 1. Implement Fibonacci with unit and isolated CLI coverage`\n\nApply these resolved decisions:\n\n- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The committed workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.\n- Direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`.\n- Functions return only their numeric value, with no incidental output.\n- Inputs are non-negative integers.\n- The implementation and test files are the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.\n\nResearch for this campaign established that function behavior and direct-process CLI behavior must be tested separately. Dot-sourcing is the unit-test boundary, while a child `pwsh` process is the isolation boundary for proving exact stdout. Implement production code and production tests from the specification rather than copying research artifacts.\n\n## Branch and execution order\n\nUse `experiment/shepherd-control` as the PR base branch. This is implementation task 1 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned. Task 2 must not start until this task is merged into the base branch.\n\n## Implement\n\nCreate `math-tool.ps1` with:\n\n- A parameter named `N` accepting non-negative integer input.\n- A pure `Get-Fibonacci` function that returns the numeric Fibonacci value without writing incidental output.\n- Direct script execution that calls the function and writes exactly one result line: `Fibonacci(N) = value`.\n- Correct Fibonacci results for the edge cases `N=0` and `N=1` and for representative larger non-negative values.\n\nCreate `math-tool.Tests.ps1` in the repository root with:\n\n- Dot-sourced unit coverage of `Get-Fibonacci`, including `N=0`, `N=1`, and at least one small representative value.\n- Isolated child-`pwsh` process coverage of direct CLI execution. Assert successful exit and exact stdout for the same boundary and representative inputs so function output cannot mask script-level formatting or incidental output.\n- Tests compatible with Pester 5.7.1 and the existing `eng/test-math-tool.ps1` runner.\n\nKeep the implementation straightforward and deterministic. Preserve a clean separation between the pure function's numeric return value and the script entry point's single formatted output line.\n\n## Completion gates\n\n- `math-tool.ps1` and `math-tool.Tests.ps1` are introduced together, as required by the repository-owned runner.\n- Dot-sourced tests prove `Get-Fibonacci 0` returns `0`, `Get-Fibonacci 1` returns `1`, and a representative value is correct with no incidental output.\n- Child-process tests prove direct invocation exits zero and stdout contains exactly one line in the required `Fibonacci(N) = value` format for edge and representative inputs.\n- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero.\n- The pinned pull-request workflow passes with Pester 5.7.1.\n- The PR targets `experiment/shepherd-control` and contains only changes needed for this task.\n\n## Out of scope\n\n- Do not implement factorial, operation dispatch, or task 2 behavior.\n- Do not change the canonical runner, the pinned Pester version, or the workflow to make tests pass.\n- Do not add unrelated operations, output formats, dependencies, or repository changes.\n- Do not read, copy, adapt, or promote spike source code; implement from the resolved findings above.\n",
    "reactions": {
      "url": "https://api.github.com/repos/edburns/dd-3069621-linux-x64-01/issues/2/reactions",
      "total_count": 0,
      "+1": 0,
```

</details>


---

<sub>1m 57s</sub>

### `rg`

**shepherd-task-25-given-list**

"shepherd-task-25-given-list" (~/.copilot/plugins/shepherd-task)

<details>
<summary>100 matches</summary>

```
[grep content: 90 matches across 69 file(s) under /home/edburns/.copilot/plugins/shepherd-task]

figure (2 match(es)):
  01- shepherd-task-25-given-list.md:Stage 25 (`shepherd-task-25-given-list`) owns one serial run. It validates the durable campaign
  01- shepherd-task-25-given-list.md:    participant GL as Stage 25: shepherd-task-25-given-list
README.md:- one or more `shepherd-task:25- given-list` runs.
README.md:| 25         |                                                    | `shepherd-task:25- given-list`                     | Runs selected child issues serially, invokes `shepherd-task` separately for each issue to perform stages 30 and 40, and always invokes stage 50 |

README.md:./plugins/shepherd-task/scripts/shepherd-task (2 match(es)):
  25- given-list.sh \
  25- given-list.ps1 `
README.md:- [Figure 01 — stage 25 given-list batch orchestration](figure:01- shepherd-task-25-given-list.md)
README.md:`shepherd-task:25- given-list-run.json`:
README.md:    ├── shepherd-task:25- given-list-run.json
README.md:| `scripts/shepherd-task:25- given-list.*` | Run stage 25: create a run and dispatch issues serially |
making-of.md:`shepherd-task:25- given-list-run.json`. The run begins as `running` and is
workshop.md:& 'C:/Users/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task:25- given-list.ps1' `
workshop.md:/Users/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task:25- given-list.sh 2\,3 1-math-control-remove-before-merge
workshop.md:By the time you have invoked `shepherd-task:25- given-list` the work proceeds in an entirely human hands-off manner. See `awesome-copilot-01/plugins/shepherd-task/README.md` Sections **Stage 30 readiness boundary** through **Workflow approval helper** and **Post-mortem behavior**.
test/lesson-propagation-default-contract.ps1:$stage25 = Join-Path $scriptsDirectory 'shepherd-task:25- given-list.ps1'
test/lesson-propagation-default-contract.ps1:        (Join-Path $harnessDirectory 'shepherd-task:25- given-list.ps1'),
test/lesson-propagation-default-contract.ps1:            Join-Path $harnessDirectory 'shepherd-task:25- given-list.ps1'
test/lesson-propagation-default-contract.ps1:        Join-Path $runDirectories[0].FullName 'shepherd-task:25- given-list-run.json'

skills/shepherd-task (3 match(es)):
  50- create-post-mortem/SKILL.md:This skill is designed to be invoked from `shepherd-task-25-given-list.ps1` / `shepherd-task-25-given-list.sh` in a `finally` / `trap EXIT` path so it runs for **all outcomes**, not only after success.
  50- create-post-mortem/SKILL.md:2. If `shepherd-task-25-given-list-run.json` exists, verify its campaign ID,
  20- create-issues-from-plan/SKILL.md:2. Comma-separated child issue numbers for `shepherd-task-25-given-list`.
test/cargotracker-add-change-arrival-deadline-feature/10-cargotracker-fixture-contract.sh:[[ "$(grep -Fc 'shepherd-task:25- given-list.sh' "$driver")" -eq 1 ]] ||
test/lesson-propagation-default-contract.sh:STAGE25="$SCRIPTS_DIR/shepherd-task:25- given-list.sh"

scripts/shepherd-task (5 match(es)):
  25- given-list.sh:#   ./shepherd-task-25-given-list.sh <TASK_ISSUES> <CAMPAIGN_METADATA_DIRECTORY>
  25- given-list.sh:RUN_MANIFEST="$LOG_DIR_FULL/shepherd-task-25-given-list-run.json"
  25- given-list.sh:echo "Logging shepherd-task-25-given-list run to: $LOG_DIR_FULL"
  25- given-list.ps1:$runManifestPath = Join-Path $logDirFull 'shepherd-task-25-given-list-run.json'
  25- given-list.ps1:    Write-Host "Logging shepherd-task-25-given-list run to: $logDirFull"
test/cargotracker-add-change-arrival-deadline-feature/07-driver-encoding-contract.sh:    'shepherd-task:25- given-list.sh'
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/20260902-run-treatment-control-experiment.ps1:                $manifestPath = Join-Path $_.FullName 'shepherd-task:25- given-list-run.json'

test/cargotracker-add-change-arrival-deadline-feature-treatment-control/20260902-run-treatment-control-experiment.ps1:        -Path (Join-Path $ShepherdPlugin 'scripts/shepherd-task (2 match(es)):
  25- given-list.ps1') `
  25- given-list.ps1') `
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/06-stage40-review-contract.sh:STAGE25="$REPO_ROOT/plugins/shepherd-task/scripts/shepherd-task:25- given-list.sh"
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/02-create-issues.ps1:    (Join-Path $PSScriptRoot '..' '..' 'scripts' 'shepherd-task:25- given-list.ps1')

test/simple-math/20260924 (10 match(es)):
  2032- job-logs.txt:[shepherd] Planned invocation of shepherd-task-25-given-list.sh:
  2032- job-logs.txt:  /home/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task-25-given-list.sh <TASK_ISSUE_LIST> 4-math-control-remove-before-merge
  2032- job-logs.txt:[shepherd] Actual invocation of shepherd-task-25-given-list.sh:
  2032- job-logs.txt:  /home/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task-25-given-list.sh 5\,6 4-math-control-remove-before-merge
  1746- job-logs.txt:[shepherd] Planned invocation of shepherd-task-25-given-list.sh:
  1746- job-logs.txt:  /home/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task-25-given-list.sh <TASK_ISSUE_LIST> 1-math-control-remove-before-merge
  1746- job-logs.txt:[shepherd] Actual invocation of shepherd-task-25-given-list.sh:
  1746- job-logs.txt:  /home/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task-25-given-list.sh 2\,3 1-math-control-remove-before-merge
  2015- job-logs.txt:[shepherd] Planned invocation of shepherd-task-25-given-list.sh:
  2015- job-logs.txt:  /home/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task-25-given-list.sh <TASK_ISSUE_LIST> 1-math-control-remove-before-merge
test/simple-math/02-create-issues.sh:stage25="$scripts_directory/shepherd-task:25- given-list.sh"
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/08-psncpps-contract.ps1:$stage25 = Join-Path $scriptsDirectory 'shepherd-task:25- given-list.ps1'
test/cargotracker-add-change-arrival-deadline-feature/06-stage40-review-contract.sh:STAGE25="$REPO_ROOT/plugins/shepherd-task/scripts/shepherd-task:25- given-list.sh"
test/simple-math/07-driver-encoding-contract.ps1:        'shepherd-task:25- given-list.ps1',
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/202609023-1638Z-run-treatment-control-experiment-resumeable.ps1:            'shepherd-task:25- given-list-run.json'
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/202609023-1638Z-run-treatment-control-experiment-resumeable.ps1:        'shepherd-task:25- given-list-run.json'
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/202609023-1638Z-run-treatment-control-experiment-resumeable.ps1:                'scripts/shepherd-task:25- given-list.ps1') `
test/simple-math/08-psncpps-contract.ps1:$stage25 = Join-Path $scriptsDirectory 'shepherd-task:25- given-list.ps1'
test/cargotracker-add-change-arrival-deadline-feature-treatment-control/06-stage40-review-contract.ps1:$stage25Path = Join-Path $repoRoot 'plugins/shepherd-task/scripts/shepherd-task:25- given-list.ps1'
test/simple-math/07-driver-encoding-contract.sh:    'shepherd-task:25- given-list.sh'
test/simple-math/08-psncpps-contract.sh:stage25="$scripts_directory/shepherd-task:25- given-list.sh"
test/simple-math/06-stage40-review-contract.sh:STAGE25="$REPO_ROOT/plugins/shepherd-task/scripts/shepherd-task:25- given-list.sh"
test/simple-math/06-stage40-review-contract.ps1:$stage25Path = Join-Path $repoRoot 'plugins/shepherd-task/scripts/shepherd-task:25- given-list.ps1'
test/simple-math/10-simple-math-fixture-contract.ps1:    "scripts//shepherd-task:25- given-list\.ps1"
test/cargotracker-add-change-arrival-deadline-feature/run-campaign.ps1:                $manifestPath = Join-Path $_.FullName 'shepherd-task:25- given-list-run.json'
test/cargotracker-add-change-arrival-deadline-feature/run-campaign.ps1:        'scripts/shepherd-task:25- given-list.ps1'
test/cargotracker-add-change-arrival-deadline-feature/02-create-issues.sh:    "$scripts_directory/shepherd-task:25- given-list.sh" \
test/cargotracker-add-change-arrival-deadline-feature/run-campaign.sh:        local manifest="$directory/shepherd-task:25- given-list-run.json"
test/cargotracker-add-change-arrival-deadline-feature/run-campaign.sh:stage25_script="$shepherd_plugin/scripts/shepherd-task:25- given-list.sh"
test/version-lineup-contract.sh:grep -Fq 'stageOutcomeProtocolVersion:' "$plugin_root/scripts/shepherd-task:25- given-list.sh"
scripts/shepherd-task-monitor.sh:# Run this in a SEPARATE terminal while shepherd-task:25- given-list.sh is running.
test/cargotracker-add-change-arrival-deadline-feature/08-psncpps-contract.sh:stage25="$scripts_directory/shepherd-task:25- given-list.sh"
test/cargotracker-add-change-arrival-deadline-feature/06-stage40-review-contract.ps1:$stage25Path = Join-Path $repoRoot 'plugins/shepherd-task/scripts/shepherd-task:25- given-list.ps1'
test/cargotracker-add-change-arrival-deadline-feature/08-psncpps-contract.ps1:$stage25 = Join-Path $scriptsDirectory 'shepherd-task:25- given-list.ps1'
test/cargotracker-add-change-arrival-deadline-feature/02-create-issues.ps1:    (Join-Path $PSScriptRoot '..' '..' 'scripts' 'shepherd-task:25- given-list.ps1')
test/simple-math/10-simple-math-fixture-contract.sh:[[ "$(grep -Fc 'scripts/shepherd-task:25- given-list.sh' "$driver")" -eq 1 ]] ||
scripts/shepherd-task.ps1:    Existing shepherd-task:25- given-list run directory.
test/simple-math/02-create-issues.ps1:    (Join-Path $PSScriptRoot '..' '..' 'scripts' 'shepherd-task:25- given-list.ps1')
test/simple-math-treatment-control/02-create-issues.ps1:    (Join-Path $PSScriptRoot '..' '..' 'scripts' 'shepherd-task:25- given-list.ps1')
test/simple-math-treatment-control/08-psncpps-contract.ps1:$stage25 = Join-Path $scriptsDirectory 'shepherd-task:25- given-list.ps1'
test/simple-math-treatment-control/20260831-run-treatment-control-experiment.ps1:                $manifestPath = Join-Path $_.FullName 'shepherd-task:25- given-list-run.json'

test/simple-math-treatment-control/20260831-run-treatment-control-experiment.ps1:        -Path (Join-Path $ShepherdPlugin 'scripts/shepherd-task (2 match(es)):
  25- given-list.ps1') `
  25- given-list.ps1') `
test/cargotracker-add-change-arrival-deadline-feature/07-driver-encoding-contract.ps1:        'shepherd-task:25- given-list.ps1',
scripts/shepherd-task-monitor.ps1:    Run this in a SEPARATE terminal while shepherd-task:25- given-list.ps1 is running.

test/cargotracker-add-change-arrival-deadline-feature-treatment-control/README.md:& "$ShepherdPlugin/scripts/shepherd-task (2 match(es)):
  25- given-list.ps1" `
  25- given-list.ps1" `
test/cargotracker-add-change-arrival-deadline-feature/10-cargotracker-fixture-contract.ps1:    "scripts//shepherd-task:25- given-list\.ps1"

test/simple-math-treatment-control/README.md:& "$ShepherdPlugin/scripts/shepherd-task (2 match(es)):
  25- given-list.ps1" `
  25- given-list.ps1" `
test/simple-math-treatment-control/06-stage40-review-contract.ps1:$stage25Path = Join-Path $repoRoot 'plugins/shepherd-task/scripts/shepherd-task:25- given-list.ps1'
test/simple-math/run-campaign.ps1:                $manifestPath = Join-Path $_.FullName 'shepherd-task:25- given-list-run.json'
test/simple-math/run-campaign.ps1:        'scripts/shepherd-task:25- given-list.ps1'
test/simple-math/run-campaign.sh:        local manifest="$directory/shepherd-task:25- given-list-run.json"
test/simple-math/run-campaign.sh:    local stage25_script="$shepherd_plugin/scripts/shepherd-task:25- given-list.sh"
test/simple-math-treatment-control/06-stage40-review-contract.sh:STAGE25="$REPO_ROOT/plugins/shepherd-task/scripts/shepherd-task:25- given-list.sh"
```

</details>


---

<sub>2m 1s</sub>

### Copilot

Created and verified two ordered, unassigned child issues under #1:

| Implementation subsection | Issue | Title | URL |
|---|---:|---|---|
| 1. Fibonacci implementation and coverage | #2 | Implement Fibonacci with unit and isolated CLI coverage | https://github.com/edburns/dd-3069621-linux-x64-01/issues/2 |
| 2. Factorial and dispatch | #3 | Add factorial and operation dispatch | https://github.com/edburns/dd-3069621-linux-x64-01/issues/3 |

**Stage-25 issue list:** `2,3`

```bash
/home/edburns/.copilot/plugins/shepherd-task/scripts/shepherd-task-25-given-list.sh \
  '2,3' \
  '1-math-control-remove-before-merge'
```

Both bodies exactly match their persisted drafts, both issues are open and unassigned, and child order/linkage passed the supplied verifier. They were created **without an issue type** because the repository is user-owned. The authoritative `stage-20-result.json` status is `complete`.

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>
