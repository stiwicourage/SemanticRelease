BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionLabel.ps1')
}

Describe 'Resolve-SemanticReleaseVersionLabel' {
    It 'returns Major for breaking change footers' {
        Resolve-SemanticReleaseVersionLabel -Message @('feat: add x', 'BREAKING CHANGE: remove old') | Should -Be 'Major'
    }

    It 'returns Major for bang syntax' {
        Resolve-SemanticReleaseVersionLabel -Message @('feat!: drop legacy') | Should -Be 'Major'
    }

    It 'returns Minor for a feat commit' {
        Resolve-SemanticReleaseVersionLabel -Message @('feat: add x') | Should -Be 'Minor'
    }

    It 'returns Patch for a fix commit' {
        Resolve-SemanticReleaseVersionLabel -Message @('fix: a bug') | Should -Be 'Patch'
    }

    It 'defaults to Patch when nothing matches' {
        Resolve-SemanticReleaseVersionLabel -Message @('chore: cleanup') | Should -Be 'Patch'
    }
}
