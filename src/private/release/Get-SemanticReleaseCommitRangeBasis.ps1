function Get-SemanticReleaseCommitRangeBasis {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ProjectRoot
    )

    if (-not (Test-SemanticReleaseGitAvailable)) {
        return Get-SemanticReleaseCommitRangeBasisResult -ProjectRoot $ProjectRoot -IsRepository:$false
    }

    $repositoryResult = Invoke-SemanticReleaseGitCommand -ProjectRoot $ProjectRoot -Arguments @('rev-parse', '--is-inside-work-tree')
    $repositoryState = Get-SemanticReleaseGitCommandOutputText -Result $repositoryResult
    if ($repositoryResult.ExitCode -ne 0 -or $repositoryState -ne 'true') {
        return Get-SemanticReleaseCommitRangeBasisResult -ProjectRoot $ProjectRoot -IsRepository:$false
    }

    $lastTagResult = Invoke-SemanticReleaseGitCommand -ProjectRoot $ProjectRoot -Arguments @('describe', '--tags', '--abbrev=0')
    $lastTag = Get-SemanticReleaseGitCommandOutputText -Result $lastTagResult
    if ($lastTagResult.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($lastTag)) {
        return Get-SemanticReleaseCommitRangeBasisResult -ProjectRoot $ProjectRoot -IsRepository -LastTag $lastTag
    }

    return Get-SemanticReleaseCommitRangeBasisResult -ProjectRoot $ProjectRoot -IsRepository
}

function Get-SemanticReleaseCommitRangeBasisResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ProjectRoot,
        [switch]$IsRepository,
        [string]$LastTag
    )

    $hasVersionTag = -not [string]::IsNullOrWhiteSpace($LastTag)
    $revisionRange = $null
    if ($hasVersionTag) {
        $revisionRange = "$LastTag..HEAD"
    }

    return [pscustomobject]@{
        ProjectRoot   = $ProjectRoot
        IsRepository  = [bool]$IsRepository
        HasVersionTag = $hasVersionTag
        LastTag       = $LastTag
        RevisionRange = $revisionRange
    }
}
