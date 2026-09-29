function Get-SemanticReleaseGitCommandOutputText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Result
    )

    return (@($Result.Output) -join [Environment]::NewLine).Trim()
}
