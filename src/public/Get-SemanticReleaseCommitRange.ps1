function Get-SemanticReleaseCommitRange {
    [CmdletBinding()]
    param(
        [string]$ProjectRoot = (Get-Location).Path
    )

    return Get-SemanticReleaseCommitRangeBasis -ProjectRoot $ProjectRoot
}
