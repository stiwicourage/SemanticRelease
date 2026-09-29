BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Get-SemanticReleaseCommitRange.ps1')
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseCommitRangeBasis.ps1')
}

Describe 'Get-SemanticReleaseCommitRange' {
    It 'delegates to Get-SemanticReleaseCommitRangeBasis' {
        Mock Get-SemanticReleaseCommitRangeBasis {
            return [pscustomobject]@{
                ProjectRoot = '/repo'
                IsRepository = $true
                HasVersionTag = $true
                LastTag = 'v1.0.0'
                RevisionRange = 'v1.0.0..HEAD'
            }
        }

        $result = Get-SemanticReleaseCommitRange -ProjectRoot '/repo'

        $result.LastTag | Should -Be 'v1.0.0'
        Should -Invoke Get-SemanticReleaseCommitRangeBasis -Times 1 -Exactly
    }
}
