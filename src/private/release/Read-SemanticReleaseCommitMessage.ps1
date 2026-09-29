function Read-SemanticReleaseCommitMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ProjectRoot
    )

    $commitRangeBasis = Get-SemanticReleaseCommitRangeBasis -ProjectRoot $ProjectRoot
    if (-not $commitRangeBasis.IsRepository) {
        return @()
    }

    $format = '%s%n%b%n--END-COMMIT--'
    $logResult = Get-SemanticReleaseCommitLogResult -ProjectRoot $ProjectRoot -Format $format -CommitRangeBasis $commitRangeBasis
    return @(ConvertFrom-SemanticReleaseCommitLogResult -Result $logResult)
}

function Get-SemanticReleaseCommitLogResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ProjectRoot,
        [Parameter(Mandatory)][string]$Format,
        [Parameter(Mandatory)][pscustomobject]$CommitRangeBasis
    )

    if ($CommitRangeBasis.HasVersionTag) {
        return Invoke-SemanticReleaseGitCommand -ProjectRoot $ProjectRoot -Arguments @('log', $CommitRangeBasis.RevisionRange, "--format=$Format")
    }

    return Invoke-SemanticReleaseGitCommand -ProjectRoot $ProjectRoot -Arguments @('log', "--format=$Format")
}

function ConvertFrom-SemanticReleaseCommitLogResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Result
    )

    if ($Result.ExitCode -ne 0 -or @($Result.Output).Count -eq 0) {
        return @()
    }

    $text = @($Result.Output) -join [Environment]::NewLine
    $commitList = $text -split '(?m)^--END-COMMIT--\r?$'
    return @($commitList | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}
