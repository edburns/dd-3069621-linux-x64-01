[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N
)

Set-StrictMode -Version Latest

function Get-Fibonacci {
    [OutputType([long])]
    param(
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    if ($N -lt 2) {
        return [long]$N
    }

    [long]$previous = 0
    [long]$current = 1
    for ($index = 2; $index -le $N; $index++) {
        [long]$next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $current
}

if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    Write-Output "Fibonacci($N) = $value"
}
