## Campaign context and required reading

**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**

Read the entire plan before working. Then carefully re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`

Apply these resolved decisions:

- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The committed workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.
- Direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`.
- Functions return only their numeric value, with no incidental output.
- Inputs are non-negative integers.
- The implementation and test files are the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.

Research for this campaign established that function behavior and direct-process CLI behavior must be tested separately. Dot-sourcing is the unit-test boundary, while a child `pwsh` process is the isolation boundary for proving exact stdout. Implement production code and production tests from the specification rather than copying research artifacts.

## Branch and execution order

Use `experiment/shepherd-control` as the PR base branch. This is implementation task 1 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned. Task 2 must not start until this task is merged into the base branch.

## Implement

Create `math-tool.ps1` with:

- A parameter named `N` accepting non-negative integer input.
- A pure `Get-Fibonacci` function that returns the numeric Fibonacci value without writing incidental output.
- Direct script execution that calls the function and writes exactly one result line: `Fibonacci(N) = value`.
- Correct Fibonacci results for the edge cases `N=0` and `N=1` and for representative larger non-negative values.

Create `math-tool.Tests.ps1` in the repository root with:

- Dot-sourced unit coverage of `Get-Fibonacci`, including `N=0`, `N=1`, and at least one small representative value.
- Isolated child-`pwsh` process coverage of direct CLI execution. Assert successful exit and exact stdout for the same boundary and representative inputs so function output cannot mask script-level formatting or incidental output.
- Tests compatible with Pester 5.7.1 and the existing `eng/test-math-tool.ps1` runner.

Keep the implementation straightforward and deterministic. Preserve a clean separation between the pure function's numeric return value and the script entry point's single formatted output line.

## Completion gates

- `math-tool.ps1` and `math-tool.Tests.ps1` are introduced together, as required by the repository-owned runner.
- Dot-sourced tests prove `Get-Fibonacci 0` returns `0`, `Get-Fibonacci 1` returns `1`, and a representative value is correct with no incidental output.
- Child-process tests prove direct invocation exits zero and stdout contains exactly one line in the required `Fibonacci(N) = value` format for edge and representative inputs.
- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero.
- The pinned pull-request workflow passes with Pester 5.7.1.
- The PR targets `experiment/shepherd-control` and contains only changes needed for this task.

## Out of scope

- Do not implement factorial, operation dispatch, or task 2 behavior.
- Do not change the canonical runner, the pinned Pester version, or the workflow to make tests pass.
- Do not add unrelated operations, output formats, dependencies, or repository changes.
- Do not read, copy, adapt, or promote spike source code; implement from the resolved findings above.
