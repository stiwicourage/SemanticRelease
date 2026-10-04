BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Update-SemanticReleaseVersion.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionUpdateContext.ps1')
    . (Join-Path $projectRoot 'src/private/release/Invoke-SemanticReleaseVersionUpdate.ps1')
}

Describe 'Update-SemanticReleaseVersion' {
    It 'delegates to the version update workflow when changes are applied' {
        Mock Get-SemanticReleaseVersionUpdateContext {
            return [pscustomobject]@{
                Target = 'project.json'
                Action = 'Update version to 1.2.4'
                WhatIfResult = [pscustomobject]@{ Applied = $false; NewVersion = '1.2.4' }
            }
        }
        Mock Invoke-SemanticReleaseVersionUpdate { return [pscustomobject]@{ Applied = $true; NewVersion = '1.2.4' } }

        $result = Update-SemanticReleaseVersion -Path '/repo/project.json' -Confirm:$false

        $result.Applied | Should -BeTrue
        $result.NewVersion | Should -Be '1.2.4'
        Should -Invoke Get-SemanticReleaseVersionUpdateContext -Times 1 -Exactly
        Should -Invoke Invoke-SemanticReleaseVersionUpdate -Times 1 -Exactly
    }

    It 'returns the WhatIf result without writing changes' {
        Mock Get-SemanticReleaseVersionUpdateContext {
            return [pscustomobject]@{
                Target = 'gradle.properties'
                Action = 'Update version to 1.2.3-preview02'
                WhatIfResult = [pscustomobject]@{ Applied = $false; NewVersion = '1.2.3-preview02' }
            }
        }
        Mock Invoke-SemanticReleaseVersionUpdate {}

        $result = Update-SemanticReleaseVersion -Path '/repo/gradle.properties' -Preview -WhatIf

        $result.Applied | Should -BeFalse
        $result.NewVersion | Should -Be '1.2.3-preview02'
        Should -Invoke Invoke-SemanticReleaseVersionUpdate -Times 0
    }
}
