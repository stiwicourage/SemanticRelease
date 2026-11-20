function Get-SemanticReleaseNextVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion,
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string]$Label = 'Patch',
        [switch]$Preview
    )

    return Get-SemanticReleaseVersionPlan -CurrentVersion $CurrentVersion -Label $Label -PreviewRelease:$Preview
}
