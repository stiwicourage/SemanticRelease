function Get-SemanticReleaseNoCommitMessage {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Context
    )

    $unchanged = "$($Context.Target) stays at $($Context.PreviousVersion)."
    if ([string]::IsNullOrWhiteSpace($Context.LastTag)) {
        return "No commits found in the repository. $unchanged Create an initial commit first."
    }

    return "No commits found since version tag '$($Context.LastTag)'. $unchanged"
}
