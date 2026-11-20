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
                NewVersion = [semver]'1.2.4'
            }
        }

        $result = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3') -Label Patch

        $result.NewVersion.ToString() | Should -Be '1.2.4'
        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { -not $PreviewRelease } -Times 1 -Exactly
    }

    It 'requests a preview plan with <Parameter>' -ForEach @(
        @{ Parameter = 'Preview' }
        @{ Parameter = 'PreviewRelease' }
    ) {
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.4-preview' } }
        $previewParameter = @{ $Parameter = $true }

        $null = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3') @previewParameter

        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { $PreviewRelease } -Times 1 -Exactly
    }

    It 'exposes one Preview switch for the release mode' {
        $parameters = (Get-Command Get-SemanticReleaseNextVersion).Parameters

        $parameters.Keys | Should -Not -Contain 'StableRelease'
        $parameters['Preview'].SwitchParameter | Should -BeTrue
    }
}
