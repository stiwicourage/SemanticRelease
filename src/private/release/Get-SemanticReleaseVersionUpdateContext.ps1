function Get-SemanticReleaseVersionUpdateContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$ProjectRoot,
        [AllowEmptyString()][string]$Key,
        [switch]$PreviewRelease
    )

    $fileContext = Get-SemanticReleaseVersionFileContext -Path $Path -Key $Key
    $commitMessages = @(Read-SemanticReleaseCommitMessage -ProjectRoot $ProjectRoot)
    $label = Resolve-SemanticReleaseVersionLabel -Message $commitMessages
    $releaseOptions = Get-SemanticReleaseVersionUpdateReleaseOption -PreviewRelease:$PreviewRelease
    $versionPlan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]$fileContext.PreviousVersion) -Label $label -PreviewRelease:$releaseOptions.PreviewRelease -StableRelease:$releaseOptions.StableRelease
    $changeInfo = Get-SemanticReleaseVersionUpdateChangeInfo -FileContext $fileContext -NewVersion $versionPlan.NewVersion.ToString()
    $whatIfResult = Get-SemanticReleaseVersionUpdateWriteResult -Format $fileContext.Format -ChangeInfo $changeInfo

    return [pscustomobject]@{
        Format = $fileContext.Format
        Path = $fileContext.Path
        Target = [System.IO.Path]::GetFileName($fileContext.Path)
        Key = $fileContext.Key
        PreviousVersion = $fileContext.PreviousVersion
        NewVersion = $versionPlan.NewVersion.ToString()
        Label = $label
        ReleaseType = $releaseOptions.ReleaseType
        PreviewRelease = [bool]$PreviewRelease
        CommitMessages = $commitMessages
        CommitCount = $commitMessages.Count
        Action = "Update $($fileContext.Key) to $($versionPlan.NewVersion)"
        WhatIfResult = $whatIfResult
    }
}

function Get-SemanticReleaseVersionFileContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [AllowEmptyString()][string]$Key
    )

    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
    switch ($extension) {
        '.json' {
            $resolvedKey = Get-SemanticReleaseVersionTargetKey -Key $Key -DefaultKey 'Version'
            $jsonData = Read-SemanticReleaseJsonData -JsonPath $Path
            if (-not $jsonData.ContainsKey($resolvedKey)) {
                throw "JSON key '$resolvedKey' was not found in $Path"
            }

            return @{
                Format = 'Json'
                Path = $Path
                Key = $resolvedKey
                PreviousVersion = [string]$jsonData[$resolvedKey]
            }
        }
        '.properties' {
            $resolvedKey = Get-SemanticReleaseVersionTargetKey -Key $Key -DefaultKey 'version'
            $propertiesData = Read-SemanticReleasePropertiesData -PropertiesPath $Path -Key $resolvedKey
            return @{
                Format = 'Properties'
                Path = $Path
                Key = $resolvedKey
                PreviousVersion = [string]$propertiesData.PreviousVersion
            }
        }
        default {
            throw "Unsupported version file extension '$extension'. Supported extensions are .json and .properties."
        }
    }
}

function Get-SemanticReleaseVersionTargetKey {
    [CmdletBinding()]
    param(
        [AllowEmptyString()][string]$Key,
        [Parameter(Mandatory)][string]$DefaultKey
    )

    if ([string]::IsNullOrWhiteSpace($Key)) {
        return $DefaultKey
    }

    return $Key
}

function Get-SemanticReleaseVersionUpdateReleaseOption {
    [CmdletBinding()]
    param(
        [switch]$PreviewRelease
    )

    $releaseType = 'Default'
    if ($PreviewRelease) {
        $releaseType = 'Preview'
    }

    return @{
        PreviewRelease = [bool]$PreviewRelease
        StableRelease = $false
        ReleaseType = $releaseType
    }
}

function Get-SemanticReleaseVersionUpdateChangeInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$FileContext,
        [Parameter(Mandatory)][string]$NewVersion
    )

    return @{
        Path = $FileContext.Path
        Key = $FileContext.Key
        PreviousVersion = $FileContext.PreviousVersion
        NewVersion = $NewVersion
    }
}

function Get-SemanticReleaseVersionUpdateWriteResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Format,
        [Parameter(Mandatory)][hashtable]$ChangeInfo
    )

    if ($Format -eq 'Json') {
        return Get-SemanticReleaseJsonVersionWriteResult -ChangeInfo $ChangeInfo
    }

    return Get-SemanticReleasePropertiesVersionWriteResult -ChangeInfo $ChangeInfo
}
