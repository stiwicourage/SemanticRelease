function Resolve-SemanticReleaseReleaseOption {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ReleaseType
    )

    return @{
        PreviewRelease = $ReleaseType -eq 'Preview'
        StableRelease = $ReleaseType -eq 'Stable'
    }
}
