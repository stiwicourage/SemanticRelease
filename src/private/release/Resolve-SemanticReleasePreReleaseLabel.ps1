function Resolve-SemanticReleasePreReleaseLabel {
    [CmdletBinding()]
    param(
        [AllowNull()][semver]$CurrentVersion,
        [switch]$PreviewRelease,
        [switch]$StableRelease
    )

    if ($PreviewRelease) {
        return Resolve-SemanticReleasePreviewLabel -CurrentVersion $CurrentVersion
    }

    if ($StableRelease) {
        return $null
    }

    return $null
}

function Resolve-SemanticReleasePreviewLabel {
    [CmdletBinding()]
    param(
        [AllowNull()][semver]$CurrentVersion
    )

    if ($null -eq $CurrentVersion -or [string]::IsNullOrWhiteSpace($CurrentVersion.PreReleaseLabel)) {
        return 'preview'
    }

    return Get-SemanticReleaseNextPreReleaseLabel -PreReleaseLabel $CurrentVersion.PreReleaseLabel
}

function Get-SemanticReleaseNextPreReleaseLabel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$PreReleaseLabel
    )

    $match = [regex]::Match($PreReleaseLabel, '^(?<Stem>.*?)(?<Number>\d+)?$')
    $stem = $match.Groups['Stem'].Value
    $preReleaseNumber = $match.Groups['Number'].Value

    if ([string]::IsNullOrWhiteSpace($preReleaseNumber)) {
        return "$stem$( Get-SemanticReleaseInitialPreReleaseNumber )"
    }

    return "$stem$( Get-SemanticReleaseIncrementedPreReleaseNumber -PreReleaseNumber $preReleaseNumber )"
}

function Get-SemanticReleaseInitialPreReleaseNumber {
    [CmdletBinding()]
    param()

    return '01'
}

function Get-SemanticReleaseIncrementedPreReleaseNumber {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$PreReleaseNumber
    )

    $nextNumber = [int]$PreReleaseNumber + 1
    if ($PreReleaseNumber.Length -eq 1) {
        return $nextNumber
    }

    return $nextNumber.ToString("D$( $PreReleaseNumber.Length )")
}
