BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Import-Module (Join-Path $projectRoot 'dist/SemanticRelease/SemanticRelease.psd1') -Force
}

Describe 'Get-SemanticReleaseNextVersion integration' {
    It 'returns a preview release plan from the built module' {
        $plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3-preview01') -Label Patch -Preview

        $plan.NewVersion.ToString() | Should -Be '1.2.3-preview02'
    }

    It 'finalizes a prerelease from the built module' {
        $plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.0.0-preview01') -Label Major

        $plan.NewVersion.ToString() | Should -Be '1.0.0'
    }

    It 'keeps a breaking change on the 0.y.z line from the built module' {
        $plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'0.1.1-preview') -Label Major -WarningAction SilentlyContinue

        $plan.NewVersion.ToString() | Should -Be '0.2.0'
    }

    It 'keeps the PreviewRelease alias used by existing release pipelines' {
        $plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3') -Label Patch -PreviewRelease

        $plan.NewVersion.ToString() | Should -Be '1.2.4-preview'
    }
}
