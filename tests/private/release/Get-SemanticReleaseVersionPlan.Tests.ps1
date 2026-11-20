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

Describe 'Test-SemanticReleaseShouldPreserveInitialStableReleaseTarget' {
    It 'returns true for exact stable 1.0.0 without preview mode' {
        Test-SemanticReleaseShouldPreserveInitialStableReleaseTarget -CurrentVersion ([semver]'1.0.0') | Should -BeTrue
    }

    It 'returns false when preview mode is requested' {
        Test-SemanticReleaseShouldPreserveInitialStableReleaseTarget -CurrentVersion ([semver]'1.0.0') -PreviewRelease | Should -BeFalse
    }

    It 'returns false when the current version is already a prerelease' {
        Test-SemanticReleaseShouldPreserveInitialStableReleaseTarget -CurrentVersion ([semver]'1.0.0-preview01') | Should -BeFalse
    }

    It 'returns false for other stable versions' {
        Test-SemanticReleaseShouldPreserveInitialStableReleaseTarget -CurrentVersion ([semver]'1.0.1') | Should -BeFalse
    }
}

Describe 'Get-SemanticReleaseVersionPlan for exact stable 1.0.0' {
    It 'keeps 1.0.0 for <Scenario>' -ForEach @(
        @{ Scenario = 'fix commits'; Label = 'Patch' }
        @{ Scenario = 'feature commits'; Label = 'Minor' }
        @{ Scenario = 'breaking commits'; Label = 'Major' }
    ) {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.0.0') -Label $Label

        $plan.NewVersion.ToString() | Should -Be '1.0.0'
    }

    It 'still moves preview bumps to 1.0.1-preview' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.0.0') -Label Major -PreviewRelease

        $plan.NewVersion.ToString() | Should -Be '1.0.1-preview'
    }
}

Describe 'Get-SemanticReleaseVersionPlan for major version zero' {
    It 'plans <CurrentVersion> with a breaking change as <Expected>' -ForEach @(
        @{ CurrentVersion = '0.1.0'; Expected = '0.2.0' }
        @{ CurrentVersion = '0.1.1-preview'; Expected = '0.2.0' }
        @{ CurrentVersion = '0.2.0-preview01'; Expected = '0.2.0' }
    ) {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]$CurrentVersion) -Label Major -StableRelease -WarningAction SilentlyContinue

        $plan.NewVersion.ToString() | Should -Be $Expected
        $plan.Label | Should -Be 'Major'
        $plan.EffectiveLabel | Should -Be 'Minor'
    }

    It 'warns that 1.0.0 must be set manually when a breaking change is kept on 0.y.z' {
        $null = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'0.1.0') -Label Major -WarningVariable warnings -WarningAction SilentlyContinue

        $warnings | Should -HaveCount 1
        $warnings[0].Message | Should -Match 'Set 1\.0\.0 manually'
    }

    It 'keeps <Label> bumps unchanged on 0.y.z without warning' -ForEach @(
        @{ Label = 'Minor'; Expected = '0.2.0' }
        @{ Label = 'Patch'; Expected = '0.1.1' }
    ) {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'0.1.0') -Label $Label -WarningVariable warnings

        $plan.NewVersion.ToString() | Should -Be $Expected
        $plan.EffectiveLabel | Should -Be $Label
        $warnings | Should -HaveCount 0
    }

    It 'keeps preview bumps on the next patch preview track without warning' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'0.1.0') -Label Major -PreviewRelease -WarningVariable warnings

        $plan.NewVersion.ToString() | Should -Be '0.1.1-preview'
        $warnings | Should -HaveCount 0
    }

    It 'still applies major bumps normally from 1.y.z' {
        $plan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]'1.2.3') -Label Major -WarningVariable warnings

        $plan.NewVersion.ToString() | Should -Be '2.0.0'
        $plan.EffectiveLabel | Should -Be 'Major'
        $warnings | Should -HaveCount 0
    }
}
