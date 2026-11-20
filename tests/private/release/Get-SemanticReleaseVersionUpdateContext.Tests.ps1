BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionUpdateContext.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseCommitRangeBasis.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleaseJsonData.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleasePropertiesData.ps1')
    . (Join-Path $projectRoot 'src/private/release/Read-SemanticReleaseCommitMessage.ps1')
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleaseVersionLabel.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionPlan.ps1')
}

Describe 'Get-SemanticReleaseVersionUpdateContext' {
    BeforeEach {
        Mock Get-SemanticReleaseCommitRangeBasis {
            return [pscustomobject]@{ IsRepository = $true; HasVersionTag = $true; LastTag = 'v1.2.3'; RevisionRange = 'v1.2.3..HEAD' }
        }
    }

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
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.3-preview02'; EffectiveLabel = 'Minor' } }

        $context = Get-SemanticReleaseVersionUpdateContext -Path '/repo/gradle.properties' -ProjectRoot '/repo' -PreviewRelease

        $context.Format | Should -Be 'Properties'
        $context.Key | Should -Be 'version'
        $context.Label | Should -Be 'Minor'
        $context.EffectiveLabel | Should -Be 'Minor'
        $context.PreviousVersion | Should -Be '1.2.3-preview01'
        $context.NewVersion | Should -Be '1.2.3-preview02'
        $context.CommitCount | Should -Be 1
        $context.HasCommits | Should -BeTrue
        $context.LastTag | Should -Be 'v1.2.3'
        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { $PreviewRelease -and $Label -eq 'Minor' } -Times 1 -Exactly
    }

    It 'uses the JSON Version key by default when no key is supplied' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Read-SemanticReleaseCommitMessage { return @('fix: correct release docs') }
        Mock Resolve-SemanticReleaseVersionLabel { return 'Patch' }
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.4'; EffectiveLabel = 'Minor' } }

        $context = Get-SemanticReleaseVersionUpdateContext -Path '/repo/project.json' -ProjectRoot '/repo'

        $context.Format | Should -Be 'Json'
        $context.Key | Should -Be 'Version'
        $context.PreviousVersion | Should -Be '1.2.3'
        $context.NewVersion | Should -Be '1.2.4'
    }

    It 'keeps the current version without planning when a repository has no new commits' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Read-SemanticReleaseCommitMessage { return @() }
        Mock Get-SemanticReleaseVersionPlan {}

        $context = Get-SemanticReleaseVersionUpdateContext -Path '/repo/project.json' -ProjectRoot '/repo'

        $context.HasCommits | Should -BeFalse
        $context.NewVersion | Should -Be '1.2.3'
        $context.CommitCount | Should -Be 0
        $context.Label | Should -BeNullOrEmpty
        Should -Invoke Get-SemanticReleaseVersionPlan -Times 0
    }

    It 'reads commits from the same range basis it reports' {
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Read-SemanticReleaseCommitMessage { return @('fix: a bug') }
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.4'; EffectiveLabel = 'Patch' } }

        $null = Get-SemanticReleaseVersionUpdateContext -Path '/repo/project.json' -ProjectRoot '/repo'

        Should -Invoke Get-SemanticReleaseCommitRangeBasis -Times 1 -Exactly
        Should -Invoke Read-SemanticReleaseCommitMessage -ParameterFilter { $CommitRangeBasis.LastTag -eq 'v1.2.3' } -Times 1 -Exactly
    }

    It 'falls back to a patch plan outside a git repository' {
        Mock Get-SemanticReleaseCommitRangeBasis { return [pscustomobject]@{ IsRepository = $false; HasVersionTag = $false } }
        Mock Read-SemanticReleaseJsonData { return @{ Version = '1.2.3' } }
        Mock Read-SemanticReleaseCommitMessage { return @() }
        Mock Get-SemanticReleaseVersionPlan { return [pscustomobject]@{ NewVersion = [semver]'1.2.4'; EffectiveLabel = 'Patch' } }

        $context = Get-SemanticReleaseVersionUpdateContext -Path '/repo/project.json' -ProjectRoot '/repo'

        $context.HasCommits | Should -BeTrue
        $context.NewVersion | Should -Be '1.2.4'
        Should -Invoke Get-SemanticReleaseVersionPlan -ParameterFilter { $Label -eq 'Patch' } -Times 1 -Exactly
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
