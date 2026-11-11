function Get-SemanticReleaseVersionPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion,
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string]$Label = 'Patch',
        [switch]$PreviewRelease,
        [switch]$StableRelease
    )

    $versionPart = Get-SemanticReleaseVersionPartForPlan -CurrentVersion $CurrentVersion -Label $Label -PreviewRelease:$PreviewRelease
    $releaseType = Resolve-SemanticReleasePreReleaseLabel -CurrentVersion $CurrentVersion -PreviewRelease:$PreviewRelease -StableRelease:$StableRelease
    $newVersion = [semver]::new($versionPart.Major, $versionPart.Minor, $versionPart.Patch, $releaseType, $null)

    return [pscustomobject]@{
        CurrentVersion = $CurrentVersion
        Label = $Label
        PreviewRelease = [bool]$PreviewRelease
        StableRelease = [bool]$StableRelease
        NewVersion = $newVersion
    }
}

function Get-SemanticReleaseVersionPartForPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion,
        [Parameter(Mandatory)][string]$Label,
        [switch]$PreviewRelease
    )

    if ($PreviewRelease) {
        if (-not [string]::IsNullOrWhiteSpace($CurrentVersion.PreReleaseLabel)) {
            return [pscustomobject]@{
                Major = $CurrentVersion.Major
                Minor = $CurrentVersion.Minor
                Patch = $CurrentVersion.Patch
            }
        }

        return Resolve-SemanticReleaseVersionPart -CurrentVersion $CurrentVersion -Label Patch
    }

    return Resolve-SemanticReleaseVersionPart -CurrentVersion $CurrentVersion -Label $Label
}
