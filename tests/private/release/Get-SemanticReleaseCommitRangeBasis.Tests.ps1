BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseCommitRangeBasis.ps1')
}

Describe 'Get-SemanticReleaseCommitRangeBasis' {
    It 'returns a non-repository result when git is unavailable' {
        function Test-SemanticReleaseGitAvailable { return $false }

        $result = Get-SemanticReleaseCommitRangeBasis -ProjectRoot '/repo'

        $result.IsRepository | Should -BeFalse
        $result.HasVersionTag | Should -BeFalse
        $result.LastTag | Should -BeNullOrEmpty
        $result.RevisionRange | Should -BeNullOrEmpty
    }

    It 'returns the last tag and revision range when a tag is found' {
        function Test-SemanticReleaseGitAvailable { return $true }
        function Invoke-SemanticReleaseGitCommand {
            param($ProjectRoot, $Arguments)
            $null = $ProjectRoot

            if ($Arguments[0] -eq 'rev-parse') {
                return [pscustomobject]@{ ExitCode = 0; Output = @('true') }
            }

            return [pscustomobject]@{ ExitCode = 0; Output = @('v1.2.3') }
        }
        function Get-SemanticReleaseGitCommandOutputText {
            param($Result)

            return ($Result.Output -join [Environment]::NewLine).Trim()
        }

        $result = Get-SemanticReleaseCommitRangeBasis -ProjectRoot '/repo'

        $result.IsRepository | Should -BeTrue
        $result.HasVersionTag | Should -BeTrue
        $result.LastTag | Should -Be 'v1.2.3'
        $result.RevisionRange | Should -Be 'v1.2.3..HEAD'
    }

    It 'returns repository scope without a revision range when no tag is found' {
        function Test-SemanticReleaseGitAvailable { return $true }
        function Invoke-SemanticReleaseGitCommand {
            param($ProjectRoot, $Arguments)
            $null = $ProjectRoot

            if ($Arguments[0] -eq 'rev-parse') {
                return [pscustomobject]@{ ExitCode = 0; Output = @('true') }
            }

            return [pscustomobject]@{ ExitCode = 128; Output = @() }
        }
        function Get-SemanticReleaseGitCommandOutputText {
            param($Result)

            return ($Result.Output -join [Environment]::NewLine).Trim()
        }

        $result = Get-SemanticReleaseCommitRangeBasis -ProjectRoot '/repo'

        $result.IsRepository | Should -BeTrue
        $result.HasVersionTag | Should -BeFalse
        $result.LastTag | Should -BeNullOrEmpty
        $result.RevisionRange | Should -BeNullOrEmpty
    }
}
