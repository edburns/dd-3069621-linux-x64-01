[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N,

    [ValidateSet('fibonacci', 'factorial')]
    [string]$Operation = 'fibonacci'
)

function Get-Fibonacci {
    [OutputType([bigint])]
    param(
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    if ($N -lt 2) {
        return [bigint]$N
    }

    [bigint]$previous = 0
    [bigint]$current = 1
    for ($index = 2; $index -le $N; $index++) {
        [bigint]$next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $current
}

function Get-Factorial {
    [OutputType([bigint])]
    param(
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [bigint]$result = 1
    for ($index = 2; $index -le $N; $index++) {
        $result *= $index
    }

    return $result
}

if ($MyInvocation.InvocationName -ne '.') {
    switch ($Operation) {
        'fibonacci' {
            $value = Get-Fibonacci -N $N
            Write-Output "Fibonacci($N) = $value"
        }
        'factorial' {
            $value = Get-Factorial -N $N
            Write-Output "Factorial($N) = $value"
        }
    }
}
