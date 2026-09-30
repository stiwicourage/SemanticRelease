BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Set-SemanticReleasePropertiesVersion.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleasePropertiesData.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Write-SemanticReleasePropertiesData.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionPlan.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleasePropertiesVersionWriteResult.ps1')
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseReleaseOption.ps1')
}

Describe 'Set-SemanticReleasePropertiesVersion' {
    It 'writes a new version and reports Applied true' {
        Mock Read-SemanticReleasePropertiesData {
            return @{
                Path = '/tmp/gradle.properties'
                Key = 'version'
                PreviousVersion = '1.2.3'
            }
        }
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{ NewVersion = [semver]'1.2.4' }
        }
        Mock Write-SemanticReleasePropertiesData {}

        $result = Set-SemanticReleasePropertiesVersion -Path '/tmp/gradle.properties' -Confirm:$false

        $result.NewVersion | Should -Be '1.2.4'
        $result.PreviousVersion | Should -Be '1.2.3'
        $result.Applied | Should -BeTrue
        Should -Invoke Write-SemanticReleasePropertiesData -Times 1
    }

    It 'maps Stable release type to the stable plan option' {
        Mock Read-SemanticReleasePropertiesData {
            return @{
                Path = '/tmp/gradle.properties'
                Key = 'version'
                PreviousVersion = '1.2.3-preview01'
            }
        }
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{ NewVersion = [semver]'1.2.3' }
        }
        Mock Write-SemanticReleasePropertiesData {}

        Set-SemanticReleasePropertiesVersion -Path '/tmp/gradle.properties' -ReleaseType Stable -Confirm:$false | Out-Null

        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { $StableRelease -and -not $PreviewRelease }
    }

    It 'returns Applied false under WhatIf' {
        Mock Read-SemanticReleasePropertiesData {
            return @{
                Path = '/tmp/gradle.properties'
                Key = 'version'
                PreviousVersion = '1.2.3'
            }
        }
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{ NewVersion = [semver]'1.2.4' }
        }
        Mock Write-SemanticReleasePropertiesData {}

        $result = Set-SemanticReleasePropertiesVersion -Path '/tmp/gradle.properties' -WhatIf

        $result.Applied | Should -BeFalse
        Should -Invoke Write-SemanticReleasePropertiesData -Times 0
    }
}
