BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseNoCommitMessage.ps1')
}

Describe 'Get-SemanticReleaseNoCommitMessage' {
    It 'names the latest version tag when no commits follow it' {
        $context = [pscustomobject]@{ Target = 'project.json'; PreviousVersion = '1.2.3'; LastTag = 'v1.2.3' }

        Get-SemanticReleaseNoCommitMessage -Context $context |
            Should -Be "No commits found since version tag 'v1.2.3'. project.json stays at 1.2.3."
    }

    It 'explains that the repository has no commits when no version tag exists' {
        $context = [pscustomobject]@{ Target = 'project.json'; PreviousVersion = '0.1.0'; LastTag = $null }

        Get-SemanticReleaseNoCommitMessage -Context $context |
            Should -Be 'No commits found in the repository. project.json stays at 0.1.0. Create an initial commit first.'
    }
}
