## Campaign context and required reading

**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**

Read the entire plan before working. Then carefully re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`
- `### 2. Add factorial and operation dispatch`

Apply these resolved decisions:

- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The committed workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.
- Direct CLI execution writes exactly one result line to stdout: `Fibonacci(N) = value` or `Factorial(N) = value`, according to the selected operation.
- Functions return only their numeric value, with no incidental output.
- Inputs are non-negative integers.
- This task starts only after task 1 has merged and must preserve all merged Fibonacci behavior.
- The implementation and test files remain the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.

Research for this campaign established that pure function behavior and direct-process dispatch/output behavior need distinct coverage. Dot-sourcing verifies numeric return contracts, while isolated child `pwsh` processes verify dispatch and exact stdout without contamination from the test process. Implement production code and production tests from these findings rather than copying research artifacts.

## Branch and execution order

Use `experiment/shepherd-control` as the PR base branch. This is implementation task 2 of 2 and depends on task 1 already being merged into that branch. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned and task 1 is present on the base branch.

## Implement

Extend the merged `math-tool.ps1` with:

- A pure `Get-Factorial` function that returns the numeric factorial value without writing incidental output.
- An `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining the existing `N` parameter.
- Preservation of the task 1 Fibonacci function and direct-invocation behavior. Existing Fibonacci invocations must remain valid; selecting Fibonacci must write exactly `Fibonacci(N) = value`.
- Factorial direct execution that writes exactly `Factorial(N) = value`.
- Correct factorial results for `N=0`, `N=1`, and at least one small representative value.

Extend `math-tool.Tests.ps1` with focused coverage that:

- Dot-sources the script and verifies `Get-Factorial` returns numeric results for `0`, `1`, and a representative value without incidental output.
- Runs the script in isolated child `pwsh` processes to prove the operation parameter selects the correct implementation and produces exactly one correctly labeled result line.
- Retains the complete Fibonacci unit and CLI regression suite from task 1.
- Remains compatible with Pester 5.7.1 and the existing `eng/test-math-tool.ps1` runner.

Keep the public interface objective and small. Use the established PowerShell behavior needed to preserve task 1's existing Fibonacci invocation while adding explicit factorial selection; do not broaden the operation set.

## Completion gates

- Factorial unit tests prove `0! = 1`, `1! = 1`, and at least one representative value is correct, with numeric-only function output.
- Isolated CLI tests prove both operation paths exit zero and emit exactly one line with the required operation-specific label and value.
- A discriminating dispatch test invokes both operations with the same `N` where their results differ, preventing an implementation that ignores `Operation` from passing.
- All task 1 Fibonacci unit and isolated CLI tests continue to pass unchanged in behavioral intent.
- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite.
- The pinned pull-request workflow passes with Pester 5.7.1.
- The PR targets `experiment/shepherd-control` and contains only changes needed for this task.

## Out of scope

- Do not add operations beyond Fibonacci and factorial.
- Do not redesign unrelated repository code or introduce unnecessary dependencies.
- Do not change the canonical runner, the pinned Pester version, or the workflow to make tests pass.
- Do not weaken, remove, or bypass task 1's Fibonacci behavior or tests.
- Do not read, copy, adapt, or promote spike source code; implement from the resolved findings above.
