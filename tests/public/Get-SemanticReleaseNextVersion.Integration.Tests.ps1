BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Import-Module (Join-Path $projectRoot 'dist/SemanticRelease/SemanticRelease.psd1') -Force
}

Describe 'Get-SemanticReleaseNextVersion integration' {
    It 'returns a preview release plan from the built module' {
        $plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3-preview01') -Label Patch -PreviewRelease

        $plan.NewVersion.ToString() | Should -Be '1.2.3-preview02'
    }

    It 'finalizes a prerelease from the built module' {
        $plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.0.0-preview01') -Label Major -StableRelease

        $plan.NewVersion.ToString() | Should -Be '1.0.0'
    }
}
