function Resolve-SemanticReleaseVersionPart {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion,
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string]$Label = 'Patch'
    )

    if (Test-SemanticReleaseShouldFinalizePrereleaseTarget -CurrentVersion $CurrentVersion -Label $Label) {
        return Get-SemanticReleaseVersionPartObject -CurrentVersion $CurrentVersion
    }

    switch ($Label) {
        'Major' {
            return [pscustomobject]@{
                Major = $CurrentVersion.Major + 1
                Minor = 0
                Patch = 0
            }
        }
        'Minor' {
            return [pscustomobject]@{
                Major = $CurrentVersion.Major
                Minor = $CurrentVersion.Minor + 1
                Patch = 0
            }
        }
        default {
            return [pscustomobject]@{
                Major = $CurrentVersion.Major
                Minor = $CurrentVersion.Minor
                Patch = $CurrentVersion.Patch + 1
            }
        }
    }
}

function Test-SemanticReleaseShouldFinalizePrereleaseTarget {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion,
        [Parameter(Mandatory)][string]$Label
    )

    if ([string]::IsNullOrWhiteSpace($CurrentVersion.PreReleaseLabel)) {
        return $false
    }

    return (Get-SemanticReleaseTargetLabelForPrerelease -CurrentVersion $CurrentVersion) -eq $Label
}

function Get-SemanticReleaseTargetLabelForPrerelease {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion
    )

    if ($CurrentVersion.Patch -gt 0) {
        return 'Patch'
    }

    if ($CurrentVersion.Minor -gt 0) {
        return 'Minor'
    }

    return 'Major'
}

function Get-SemanticReleaseVersionPartObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][semver]$CurrentVersion
    )

    return [pscustomobject]@{
        Major = $CurrentVersion.Major
        Minor = $CurrentVersion.Minor
        Patch = $CurrentVersion.Patch
    }
}
