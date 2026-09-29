BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionPart.ps1')
}

Describe 'Get-SemanticReleaseVersionPartObject' {
    It 'mirrors current version parts' {
        $parts = Get-SemanticReleaseVersionPartObject -CurrentVersion ([semver]'1.2.3')

        $parts.Major | Should -Be 1
        $parts.Minor | Should -Be 2
        $parts.Patch | Should -Be 3
    }
}

Describe 'Get-SemanticReleaseTargetLabelForPrerelease' {
    It 'returns Patch when Patch is greater than zero' {
        Get-SemanticReleaseTargetLabelForPrerelease -CurrentVersion ([semver]'1.2.3-preview01') | Should -Be 'Patch'
    }

    It 'returns Minor when only Minor is greater than zero' {
        Get-SemanticReleaseTargetLabelForPrerelease -CurrentVersion ([semver]'1.2.0-preview01') | Should -Be 'Minor'
    }

    It 'returns Major when only Major is greater than zero' {
        Get-SemanticReleaseTargetLabelForPrerelease -CurrentVersion ([semver]'1.0.0-preview01') | Should -Be 'Major'
    }
}

Describe 'Test-SemanticReleaseShouldFinalizePrereleaseTarget' {
    It 'returns false when there is no prerelease label' {
        Test-SemanticReleaseShouldFinalizePrereleaseTarget -CurrentVersion ([semver]'1.2.3') -Label 'Patch' | Should -BeFalse
    }

    It 'returns true when the target label matches the prerelease bias' {
        Test-SemanticReleaseShouldFinalizePrereleaseTarget -CurrentVersion ([semver]'1.2.3-preview01') -Label 'Patch' | Should -BeTrue
    }
}

Describe 'Resolve-SemanticReleaseVersionPart' {
    It 'bumps major when Label is Major' {
        $parts = Resolve-SemanticReleaseVersionPart -CurrentVersion ([semver]'1.2.3') -Label Major

        $parts.Major | Should -Be 2
        $parts.Minor | Should -Be 0
        $parts.Patch | Should -Be 0
    }

    It 'bumps minor when Label is Minor' {
        $parts = Resolve-SemanticReleaseVersionPart -CurrentVersion ([semver]'1.2.3') -Label Minor

        $parts.Minor | Should -Be 3
        $parts.Patch | Should -Be 0
    }

    It 'bumps patch when Label is Patch' {
        $parts = Resolve-SemanticReleaseVersionPart -CurrentVersion ([semver]'1.2.3') -Label Patch

        $parts.Patch | Should -Be 4
    }

    It 'finalizes a prerelease without incrementing the part' {
        $parts = Resolve-SemanticReleaseVersionPart -CurrentVersion ([semver]'1.0.0-preview01') -Label Major

        $parts.Major | Should -Be 1
        $parts.Minor | Should -Be 0
        $parts.Patch | Should -Be 0
    }
}
