BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/shared/Test-SemanticReleaseGitAvailable.ps1')
}

Describe 'Test-SemanticReleaseGitAvailable' {
    It 'returns true when git is on the PATH' {
        Mock Get-Command { return [pscustomobject]@{ Name = 'git' } }

        Test-SemanticReleaseGitAvailable | Should -BeTrue
    }

    It 'returns false when git is missing' {
        Mock Get-Command { return $null }

        Test-SemanticReleaseGitAvailable | Should -BeFalse
    }
}
