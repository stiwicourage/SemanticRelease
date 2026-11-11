BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Invoke-SemanticReleaseVersionUpdate.ps1')
    . (Join-Path $projectRoot 'src/public/Set-SemanticReleaseJsonVersion.ps1')
    . (Join-Path $projectRoot 'src/public/Set-SemanticReleasePropertiesVersion.ps1')
}

Describe 'Invoke-SemanticReleaseVersionUpdate' {
    It 'writes JSON versions through Set-SemanticReleaseJsonVersion' {
        Mock Set-SemanticReleaseJsonVersion { return [pscustomobject]@{ Applied = $true } }

        $context = [pscustomobject]@{
            Format = 'Json'
            Path = '/repo/project.json'
            Target = 'project.json'
            Key = 'Version'
            Label = 'Patch'
            ReleaseType = 'Default'
            PreviousVersion = '1.2.3'
            NewVersion = '1.2.4'
            PreviewRelease = $false
            CommitMessages = @('fix: correct packaging')
            CommitCount = 1
        }

        $result = Invoke-SemanticReleaseVersionUpdate -Context $context

        $result.Applied | Should -BeTrue
        $result.Label | Should -Be 'Patch'
        $result.NewVersion | Should -Be '1.2.4'
        Should -Invoke Set-SemanticReleaseJsonVersion -ParameterFilter { $Path -eq '/repo/project.json' -and $Key -eq 'Version' -and $Label -eq 'Patch' -and $ReleaseType -eq 'Default' } -Times 1 -Exactly
    }

    It 'writes preview properties versions through Set-SemanticReleasePropertiesVersion' {
        Mock Set-SemanticReleasePropertiesVersion { return [pscustomobject]@{ Applied = $true } }

        $context = [pscustomobject]@{
            Format = 'Properties'
            Path = '/repo/gradle.properties'
            Target = 'gradle.properties'
            Key = 'version'
            Label = 'Minor'
            ReleaseType = 'Preview'
            PreviousVersion = '1.2.3-preview01'
            NewVersion = '1.2.3-preview02'
            PreviewRelease = $true
            CommitMessages = @('feat: add preview publish')
            CommitCount = 1
        }

        $result = Invoke-SemanticReleaseVersionUpdate -Context $context

        $result.Applied | Should -BeTrue
        $result.PreviewRelease | Should -BeTrue
        $result.NewVersion | Should -Be '1.2.3-preview02'
        Should -Invoke Set-SemanticReleasePropertiesVersion -ParameterFilter { $Path -eq '/repo/gradle.properties' -and $Key -eq 'version' -and $Label -eq 'Minor' -and $ReleaseType -eq 'Preview' } -Times 1 -Exactly
    }

    It 'throws when the context format is not supported' {
        $context = [pscustomobject]@{
            Format = 'Xml'
            Path = '/repo/version.xml'
            Target = 'version.xml'
            Key = 'Version'
            Label = 'Patch'
            ReleaseType = 'Default'
            PreviousVersion = '1.2.3'
            NewVersion = '1.2.4'
            PreviewRelease = $false
            CommitMessages = @()
            CommitCount = 0
        }

        { Invoke-SemanticReleaseVersionUpdate -Context $context } | Should -Throw "Unsupported version update format 'Xml'."
    }
}
