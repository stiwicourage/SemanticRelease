BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionUpdateContext.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseJsonVersionWriteResult.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleasePropertiesVersionWriteResult.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleaseJsonData.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleasePropertiesData.ps1')
    . (Join-Path $projectRoot 'src/private/release/Read-SemanticReleaseCommitMessage.ps1')
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionLabel.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionPlan.ps1')
}

Describe 'Get-SemanticReleaseVersionUpdateContext' {
    It 'builds a preview properties context with the default key and inferred label' {
        Mock Read-SemanticReleasePropertiesData {
            return @{
                Path = '/repo/gradle.properties'
                Key = 'version'
                PreviousVersion = '1.2.3-preview01'
            }
        }
        Mock Read-SemanticReleaseCommitMessage { return @('feat: add release automation') }
        Mock Resolve-SemanticReleaseVersionLabel { return 'Minor' }
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.3-preview02' } }

        $context = Get-SemanticReleaseVersionUpdateContext -Path '/repo/gradle.properties' -ProjectRoot '/repo' -PreviewRelease

        $context.Format | Should -Be 'Properties'
        $context.Key | Should -Be 'version'
        $context.Label | Should -Be 'Minor'
        $context.PreviousVersion | Should -Be '1.2.3-preview01'
        $context.NewVersion | Should -Be '1.2.3-preview02'
        $context.CommitCount | Should -Be 1
        $context.WhatIfResult.Applied | Should -BeFalse
        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { $PreviewRelease -and $Label -eq 'Minor' } -Times 1 -Exactly
    }

    It 'uses the JSON Version key by default when no key is supplied' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Read-SemanticReleaseCommitMessage { return @('fix: correct release docs') }
        Mock Resolve-SemanticReleaseVersionLabel { return 'Patch' }
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.4' } }

        $context = Get-SemanticReleaseVersionUpdateContext -Path '/repo/project.json' -ProjectRoot '/repo'

        $context.Format | Should -Be 'Json'
        $context.Key | Should -Be 'Version'
        $context.PreviousVersion | Should -Be '1.2.3'
        $context.NewVersion | Should -Be '1.2.4'
    }

    It 'throws for unsupported version file extensions' {
        {
            Get-SemanticReleaseVersionUpdateContext -Path '/repo/version.txt' -ProjectRoot '/repo'
        } | Should -Throw "Unsupported version file extension '.txt'. Supported extensions are .json and .properties."
    }
}

Describe 'Get-SemanticReleaseVersionTargetKey' {
    It 'returns the supplied key when one is provided' {
        Get-SemanticReleaseVersionTargetKey -Key 'pluginVersion' -DefaultKey 'Version' | Should -Be 'pluginVersion'
    }
}

Describe 'Get-SemanticReleaseVersionUpdateReleaseOption' {
    It 'returns Preview when preview mode is requested' {
        $options = Get-SemanticReleaseVersionUpdateReleaseOption -PreviewRelease

        $options.PreviewRelease | Should -BeTrue
        $options.StableRelease | Should -BeFalse
        $options.ReleaseType | Should -Be 'Preview'
    }

    It 'returns Default when preview mode is not requested' {
        $options = Get-SemanticReleaseVersionUpdateReleaseOption

        $options.PreviewRelease | Should -BeFalse
        $options.ReleaseType | Should -Be 'Default'
    }
}

Describe 'Get-SemanticReleaseVersionUpdateChangeInfo' {
    It 'returns the shared change info payload' {
        $changeInfo = Get-SemanticReleaseVersionUpdateChangeInfo -FileContext @{
            Path = '/repo/project.json'
            Key = 'Version'
            PreviousVersion = '1.2.3'
        } -NewVersion '1.2.4'

        $changeInfo.Path | Should -Be '/repo/project.json'
        $changeInfo.Key | Should -Be 'Version'
        $changeInfo.PreviousVersion | Should -Be '1.2.3'
        $changeInfo.NewVersion | Should -Be '1.2.4'
    }
}

Describe 'Get-SemanticReleaseVersionUpdateWriteResult' {
    It 'uses the expected write result shape for <Format> files' -ForEach @(
        @{
            Format = 'Json'
            Target = 'project.json'
            ChangeInfo = @{
                Path = '/repo/project.json'
                Key = 'Version'
                PreviousVersion = '1.2.3'
                NewVersion = '1.2.4'
            }
        }
        @{
            Format = 'Properties'
            Target = 'gradle.properties'
            ChangeInfo = @{
                Path = '/repo/gradle.properties'
                Key = 'version'
                PreviousVersion = '1.2.3-preview01'
                NewVersion = '1.2.3-preview02'
            }
        }
    ) {
        $result = Get-SemanticReleaseVersionUpdateWriteResult -Format $Format -ChangeInfo $ChangeInfo

        $result.Target | Should -Be $Target
        $result.Applied | Should -BeFalse
    }
}
