BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Update-SemanticReleaseVersion.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionUpdateContext.ps1')
    . (Join-Path $projectRoot 'src/private/release/Invoke-SemanticReleaseVersionUpdate.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseVersionUpdateResult.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseNoCommitMessage.ps1')

    function Get-TestUpdateContext {
        param(
            [string]$NewVersion = '1.2.4',
            [bool]$HasCommits = $true
        )

        return [pscustomobject]@{
            Path = '/repo/project.json'
            Target = 'project.json'
            Key = 'Version'
            PreviousVersion = '1.2.3'
            NewVersion = $NewVersion
            Label = 'Patch'
            EffectiveLabel = 'Patch'
            PreviewRelease = $false
            CommitMessages = @('fix: correct packaging')
            CommitCount = 1
            HasCommits = $HasCommits
            LastTag = 'v1.2.3'
            Action = "Update Version to $NewVersion"
        }
    }
}

Describe 'Update-SemanticReleaseVersion' {
    It 'delegates to the version update workflow when changes are applied' {
        Mock Get-SemanticReleaseVersionUpdateContext { return Get-TestUpdateContext }
        Mock Invoke-SemanticReleaseVersionUpdate { return [pscustomobject]@{ Applied = $true; NewVersion = '1.2.4' } }

        $result = Update-SemanticReleaseVersion -Path '/repo/project.json' -Confirm:$false

        $result.Applied | Should -BeTrue
        $result.NewVersion | Should -Be '1.2.4'
        Should -Invoke Get-SemanticReleaseVersionUpdateContext -Times 1 -Exactly
        Should -Invoke Invoke-SemanticReleaseVersionUpdate -Times 1 -Exactly
    }

    It 'returns the same result shape as an applied update under WhatIf' {
        Mock Get-SemanticReleaseVersionUpdateContext { return Get-TestUpdateContext }
        Mock Invoke-SemanticReleaseVersionUpdate {}

        $result = Update-SemanticReleaseVersion -Path '/repo/project.json' -WhatIf

        $result.Applied | Should -BeFalse
        $result.NewVersion | Should -Be '1.2.4'
        $result.Label | Should -Be 'Patch'
        $result.EffectiveLabel | Should -Be 'Patch'
        $result.CommitCount | Should -Be 1
        $result.CommitMessages | Should -Be @('fix: correct packaging')
        $result.PreviewRelease | Should -BeFalse
        Should -Invoke Invoke-SemanticReleaseVersionUpdate -Times 0
    }

    It 'leaves the version unchanged and warns when there are no commits to release' {
        Mock Get-SemanticReleaseVersionUpdateContext { return Get-TestUpdateContext -NewVersion '1.2.3' -HasCommits $false }
        Mock Invoke-SemanticReleaseVersionUpdate {}

        $result = Update-SemanticReleaseVersion -Path '/repo/project.json' -Confirm:$false -WarningVariable warnings -WarningAction SilentlyContinue

        $result.Applied | Should -BeFalse
        $result.NewVersion | Should -Be '1.2.3'
        $warnings | Should -HaveCount 1
        "$warnings" | Should -Match "v1\.2\.3"
        Should -Invoke Invoke-SemanticReleaseVersionUpdate -Times 0
    }
}
