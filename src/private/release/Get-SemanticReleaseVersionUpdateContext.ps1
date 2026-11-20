function Get-SemanticReleaseVersionUpdateContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$ProjectRoot,
        [AllowEmptyString()][string]$Key,
        [switch]$PreviewRelease
    )

    $fileContext = Get-SemanticReleaseVersionFileContext -Path $Path -Key $Key
    $commitRangeBasis = Get-SemanticReleaseCommitRangeBasis -ProjectRoot $ProjectRoot
    $commitMessages = @(Read-SemanticReleaseCommitMessage -ProjectRoot $ProjectRoot -CommitRangeBasis $commitRangeBasis)
    $hasCommits = $commitMessages.Count -gt 0 -or -not $commitRangeBasis.IsRepository
    $versionChange = Get-SemanticReleaseVersionUpdateChange -PreviousVersion $fileContext.PreviousVersion -CommitMessages $commitMessages -HasCommits:$hasCommits -PreviewRelease:$PreviewRelease

    return [pscustomobject]@{
        Format = $fileContext.Format
        Path = $fileContext.Path
        Target = [System.IO.Path]::GetFileName($fileContext.Path)
        Key = $fileContext.Key
        PreviousVersion = $fileContext.PreviousVersion
        NewVersion = $versionChange.NewVersion
        Label = $versionChange.Label
        EffectiveLabel = $versionChange.EffectiveLabel
        PreviewRelease = [bool]$PreviewRelease
        CommitMessages = $commitMessages
        CommitCount = $commitMessages.Count
        HasCommits = $hasCommits
        LastTag = $commitRangeBasis.LastTag
        Action = "Update $($fileContext.Key) to $($versionChange.NewVersion)"
    }
}

function Get-SemanticReleaseVersionUpdateChange {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$PreviousVersion,
        [AllowEmptyCollection()][string[]]$CommitMessages = @(),
        [switch]$HasCommits,
        [switch]$PreviewRelease
    )

    if (-not $HasCommits) {
        return @{ NewVersion = $PreviousVersion; Label = $null; EffectiveLabel = $null }
    }

    $label = Resolve-SemanticReleaseVersionLabel -Message $CommitMessages
    $versionPlan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]$PreviousVersion) -Label $label -PreviewRelease:$PreviewRelease
    return @{
        NewVersion = $versionPlan.NewVersion.ToString()
        Label = $label
        EffectiveLabel = $versionPlan.EffectiveLabel
    }
}

function Get-SemanticReleaseVersionFileContext {
    [OutputType([hashtable])]
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
    [OutputType([string])]
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
