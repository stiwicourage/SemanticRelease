function Resolve-SemanticReleaseReleaseOption {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ReleaseType
    )

    return @{
        PreviewRelease = $ReleaseType -eq 'Preview'
        StableRelease = $ReleaseType -eq 'Stable'
    }
}
