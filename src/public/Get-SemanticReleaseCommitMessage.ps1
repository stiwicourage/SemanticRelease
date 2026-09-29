function Get-SemanticReleaseCommitMessage {
    [CmdletBinding()]
    param(
        [string]$ProjectRoot = (Get-Location).Path
    )

    return Read-SemanticReleaseCommitMessage -ProjectRoot $ProjectRoot
}
