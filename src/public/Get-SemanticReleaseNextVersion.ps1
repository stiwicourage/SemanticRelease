function Get-SemanticReleaseNextVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion,
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string]$Label = 'Patch',
        [switch]$PreviewRelease,
        [switch]$StableRelease
    )

    return Get-SemanticReleaseVersionPlan -CurrentVersion $CurrentVersion -Label $Label -PreviewRelease:$PreviewRelease -StableRelease:$StableRelease
}
