BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionPlan.ps1')
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionPart.ps1')
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleasePreReleaseLabel.ps1')
}

Describe 'Get-SemanticReleaseVersionPartForPlan' {
    It 'returns the current parts when previewing an existing prerelease version' {
        $parts = Get-SemanticReleaseVersionPartForPlan -CurrentVersion ([semver]'1.2.3-preview01') -Label Patch -PreviewRelease

        $parts.Major | Should -Be 1
        $parts.Minor | Should -Be 2
        $parts.Patch | Should -Be 3
    }

    It 'returns a patch bump when previewing a stable version' {
        $parts = Get-SemanticReleaseVersionPartForPlan -CurrentVersion ([semver]'1.2.3') -Label Major -PreviewRelease

        $parts.Major | Should -Be 1
        $parts.Minor | Should -Be 2
        $parts.Patch | Should -Be 4
    }
}

Describe 'Get-SemanticReleaseVersionPlan' {
    It 'returns a stable patch release plan by default' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.2.3') -Label Patch

        $plan.CurrentVersion.ToString() | Should -Be '1.2.3'
        $plan.NewVersion.ToString() | Should -Be '1.2.4'
    }

    It 'returns a preview release plan with preview label for a stable version' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.2.3') -Label Major -PreviewRelease

        $plan.NewVersion.ToString() | Should -Be '1.2.4-preview'
    }

    It 'increments an existing preview label without changing version parts' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.2.3-preview01') -Label Patch -PreviewRelease

        $plan.NewVersion.ToString() | Should -Be '1.2.3-preview02'
    }

    It 'finalizes an existing prerelease when the target label matches' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.0.0-preview01') -Label Major -StableRelease

        $plan.NewVersion.ToString() | Should -Be '1.0.0'
    }
}
