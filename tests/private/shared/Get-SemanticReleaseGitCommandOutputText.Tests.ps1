BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/shared/Get-SemanticReleaseGitCommandOutputText.ps1')
}

Describe 'Get-SemanticReleaseGitCommandOutputText' {
    It 'joins output lines with a newline and trims the result' {
        $result = Get-SemanticReleaseGitCommandOutputText -Result ([pscustomobject]@{
                ExitCode = 0
                Output = @('line1', 'line2', '')
            })

        $result | Should -Be ("line1$( [Environment]::NewLine )line2")
    }

    It 'returns an empty string when output is empty' {
        Get-SemanticReleaseGitCommandOutputText -Result ([pscustomobject]@{
                ExitCode = 0
                Output = @()
            }) | Should -Be ''
    }
}
