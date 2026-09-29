BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Get-SemanticReleaseNextVersion.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionPlan.ps1')
}

Describe 'Get-SemanticReleaseNextVersion' {
    It 'delegates to Get-SemanticReleaseVersionPlan' {
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{
                CurrentVersion = [semver]'1.2.3'
                Label = 'Patch'
                PreviewRelease = $false
                StableRelease = $false
                NewVersion = [semver]'1.2.4'
            }
        }

        $result = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3') -Label Patch

        $result.NewVersion.ToString() | Should -Be '1.2.4'
        Should -Invoke Get-SemanticReleaseVersionPlan -Times 1 -Exactly
    }
}
