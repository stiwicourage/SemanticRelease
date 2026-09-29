BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Get-SemanticReleaseCommitMessage.ps1')
    . (Join-Path $projectRoot 'src/private/release/Read-SemanticReleaseCommitMessage.ps1')
}

Describe 'Get-SemanticReleaseCommitMessage' {
    It 'delegates to Read-SemanticReleaseCommitMessage' {
        Mock Read-SemanticReleaseCommitMessage { return @('feat: add x') }

        $result = Get-SemanticReleaseCommitMessage -ProjectRoot '/repo'

        $result | Should -Be @('feat: add x')
        Should -Invoke Read-SemanticReleaseCommitMessage -Times 1 -Exactly
    }
}
