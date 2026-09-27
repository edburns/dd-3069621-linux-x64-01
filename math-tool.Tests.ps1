Describe 'Get-Fibonacci' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'returns only zero for N=0' {
        $output = @(Get-Fibonacci -N 0)

        $output | Should -HaveCount 1
        $output[0] | Should -Be 0
    }

    It 'returns only one for N=1' {
        $output = @(Get-Fibonacci -N 1)

        $output | Should -HaveCount 1
        $output[0] | Should -Be 1
    }

    It 'returns only eight for N=6' {
        $output = @(Get-Fibonacci -N 6)

        $output | Should -HaveCount 1
        $output[0] | Should -Be 8
    }

    It 'returns the arbitrary-precision result for N=100' {
        $output = @(Get-Fibonacci -N 100)

        $output | Should -HaveCount 1
        $output[0] | Should -BeOfType ([bigint])
        $output[0] | Should -Be ([bigint]::Parse('354224848179261915075'))
    }
}

Describe 'math-tool CLI' {
    BeforeAll {
        $scriptPath = Join-Path $PSScriptRoot 'math-tool.ps1'

        function Invoke-MathTool {
            param(
                [int]$N
            )

            $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
            $startInfo.FileName = Get-Command pwsh -CommandType Application |
                Select-Object -First 1 -ExpandProperty Source
            $startInfo.RedirectStandardOutput = $true
            $startInfo.RedirectStandardError = $true
            $startInfo.UseShellExecute = $false
            [void]$startInfo.ArgumentList.Add('-NoLogo')
            [void]$startInfo.ArgumentList.Add('-NoProfile')
            [void]$startInfo.ArgumentList.Add('-File')
            [void]$startInfo.ArgumentList.Add($scriptPath)
            [void]$startInfo.ArgumentList.Add('-N')
            [void]$startInfo.ArgumentList.Add($N.ToString())

            $process = [System.Diagnostics.Process]::new()
            $process.StartInfo = $startInfo
            [void]$process.Start()
            $stdout = $process.StandardOutput.ReadToEnd()
            $stderr = $process.StandardError.ReadToEnd()
            $process.WaitForExit()

            [pscustomobject]@{
                ExitCode = $process.ExitCode
                StdOut   = $stdout
                StdErr   = $stderr
            }
        }
    }

    It 'writes exactly the expected result for N=<N>' -ForEach @(
        @{ N = 0; Expected = 0 }
        @{ N = 1; Expected = 1 }
        @{ N = 6; Expected = 8 }
    ) {
        $result = Invoke-MathTool -N $N

        $result.ExitCode | Should -Be 0
        $result.StdErr | Should -BeNullOrEmpty
        $result.StdOut | Should -Be "Fibonacci($N) = $Expected$([Environment]::NewLine)"
    }
}
