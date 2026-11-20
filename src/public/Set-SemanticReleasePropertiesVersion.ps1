function Set-SemanticReleasePropertiesVersion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)][string]$Path,
        [string]$Key = 'version',
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string]$Label = 'Patch',
        [switch]$Preview
    )

    $propertiesData = Read-SemanticReleasePropertiesData -PropertiesPath $Path -Key $Key
    $versionPlan = Get-SemanticReleaseVersionPlan -CurrentVersion ([semver]$propertiesData.PreviousVersion) -Label $Label -PreviewRelease:$Preview
    $newVersion = $versionPlan.NewVersion.ToString()
    $changeInfo = @{
        Path = $Path
        Key = $Key
        PreviousVersion = $propertiesData.PreviousVersion
        NewVersion = $newVersion
    }
    $target = [System.IO.Path]::GetFileName($Path)
    $action = "Set $Key to $newVersion"
    if (-not $PSCmdlet.ShouldProcess($target, $action)) {
        return Get-SemanticReleasePropertiesVersionWriteResult -ChangeInfo $changeInfo
    }

    Write-SemanticReleasePropertiesData -Data $propertiesData -NewVersion $newVersion
    return Get-SemanticReleasePropertiesVersionWriteResult -ChangeInfo $changeInfo -Applied
}
