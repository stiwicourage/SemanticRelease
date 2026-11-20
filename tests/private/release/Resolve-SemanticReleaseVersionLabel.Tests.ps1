BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionLabel.ps1')
}

Describe 'Resolve-SemanticReleaseVersionLabel' {
    It 'returns Major for breaking change footers' {
        Resolve-SemanticReleaseVersionLabel -Message @('feat: add x', 'BREAKING CHANGE: remove old') | Should -Be 'Major'
    }

    It 'returns Major for a breaking change footer inside a commit body' {
        $message = "feat: add x`n`nLonger description.`n`nBREAKING CHANGE: remove old"

        Resolve-SemanticReleaseVersionLabel -Message @($message) | Should -Be 'Major'
    }

    It 'returns Major for the hyphenated BREAKING-CHANGE footer token' {
        Resolve-SemanticReleaseVersionLabel -Message @("fix: a bug`n`nBREAKING-CHANGE: remove old") | Should -Be 'Major'
    }

    It 'does not return Major when breaking change only appears in prose' {
        Resolve-SemanticReleaseVersionLabel -Message @('docs: explain why this is not a breaking change') | Should -Be 'Patch'
    }

    It 'does not return Major for a lowercase breaking change footer' {
        Resolve-SemanticReleaseVersionLabel -Message @("fix: a bug`n`nbreaking change: wording only") | Should -Be 'Patch'
    }

    It 'does not return Major when the footer token is not at the start of a line' {
        Resolve-SemanticReleaseVersionLabel -Message @('feat: mention BREAKING CHANGE: in docs') | Should -Be 'Minor'
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

    It 'defaults to Patch when no commit messages are available' {
        Resolve-SemanticReleaseVersionLabel -Message @() | Should -Be 'Patch'
    }
}
