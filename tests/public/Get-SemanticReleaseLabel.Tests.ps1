BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Get-SemanticReleaseLabel.ps1')
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionLabel.ps1')
}

Describe 'Get-SemanticReleaseLabel' {
    It 'delegates to Resolve-SemanticReleaseVersionLabel' {
        Mock Resolve-SemanticReleaseVersionLabel { return 'Minor' }

        $result = Get-SemanticReleaseLabel -Message @('feat: add x')

        $result | Should -Be 'Minor'
        Should -Invoke Resolve-SemanticReleaseVersionLabel -Times 1 -Exactly
    }
}
