function Set-SemanticReleaseJsonVersion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)][string]$Path,
        [string]$Key = 'Version',
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string]$Label = 'Patch',
        [ValidateSet('Default', 'Preview', 'Stable')]
        [string]$ReleaseType = 'Default'
    )

    $jsonData = Read-SemanticReleaseJsonData -JsonPath $Path
    if (-not $jsonData.ContainsKey($Key)) {
        throw "JSON key '$Key' was not found in $Path"
    }

    $previousVersion = [string]$jsonData[$Key]
    $isPreviewRelease = $ReleaseType -eq 'Preview'
    $isStableRelease = $ReleaseType -eq 'Stable'
    $versionPlan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]$previousVersion) -Label $Label -PreviewRelease:$isPreviewRelease -StableRelease:$isStableRelease
    $newVersion = $versionPlan.NewVersion.ToString()
    $target = [System.IO.Path]::GetFileName($Path)
    $action = "Set $Key to $newVersion"
    $changeInfo = @{
        Path = $Path
        Key = $Key
        PreviousVersion = $previousVersion
        NewVersion = $newVersion
    }
    if (-not $PSCmdlet.ShouldProcess($target, $action)) {
        return Get-SemanticReleaseJsonVersionWriteResult -ChangeInfo $changeInfo
    }

    $jsonData[$Key] = $newVersion
    Write-SemanticReleaseJsonData -JsonPath $Path -Data $jsonData
    return Get-SemanticReleaseJsonVersionWriteResult -ChangeInfo $changeInfo -Applied
}
