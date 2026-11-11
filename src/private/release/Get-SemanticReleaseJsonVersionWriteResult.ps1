function Get-SemanticReleaseJsonVersionWriteResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$ChangeInfo,
        [switch]$Applied
    )

    return [pscustomobject]@{
        Path = [string]$ChangeInfo.Path
        Target = [System.IO.Path]::GetFileName([string]$ChangeInfo.Path)
        Key = [string]$ChangeInfo.Key
        PreviousVersion = [string]$ChangeInfo.PreviousVersion
        NewVersion = [string]$ChangeInfo.NewVersion
        Applied = [bool]$Applied
    }
}
