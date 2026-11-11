BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Set-SemanticReleaseJsonVersion.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleaseJsonData.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Write-SemanticReleaseJsonData.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionPlan.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseJsonVersionWriteResult.ps1')
}

Describe 'Set-SemanticReleaseJsonVersion' {
    It 'writes a new version and reports Applied true' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{ NewVersion = [semver]'1.2.4' }
        }
        Mock Write-SemanticReleaseJsonData {}

        $result = Set-SemanticReleaseJsonVersion -Path '/tmp/project.json' -Confirm:$false

        $result.NewVersion | Should -Be '1.2.4'
        $result.PreviousVersion | Should -Be '1.2.3'
        $result.Applied | Should -BeTrue
        Should -Invoke Write-SemanticReleaseJsonData -Times 1
    }

    It 'maps Preview release type to the preview plan option' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{ NewVersion = [semver]'1.2.4-preview' }
        }
        Mock Write-SemanticReleaseJsonData {}

        Set-SemanticReleaseJsonVersion -Path '/tmp/project.json' -ReleaseType Preview -Confirm:$false | Out-Null

        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { $PreviewRelease -and -not $StableRelease }
    }

    It 'returns Applied false under WhatIf' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Get-SemanticReleaseVersionPlan {
            return [pscustomobject]@{ NewVersion = [semver]'1.2.4' }
        }
        Mock Write-SemanticReleaseJsonData {}

        $result = Set-SemanticReleaseJsonVersion -Path '/tmp/project.json' -WhatIf

        $result.Applied | Should -BeFalse
        Should -Invoke Write-SemanticReleaseJsonData -Times 0
    }
}
