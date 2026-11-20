function Get-SemanticReleaseVersionUpdateResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Context,
        [switch]$Applied
    )

    return [pscustomobject]@{
        Path = $Context.Path
        Target = $Context.Target
        Key = $Context.Key
        PreviousVersion = $Context.PreviousVersion
        NewVersion = $Context.NewVersion
        Applied = [bool]$Applied
        Label = $Context.Label
        EffectiveLabel = $Context.EffectiveLabel
        PreviewRelease = [bool]$Context.PreviewRelease
        CommitMessages = @($Context.CommitMessages)
        CommitCount = $Context.CommitCount
    }
}
