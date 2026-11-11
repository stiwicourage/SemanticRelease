function Get-SemanticReleasePropertiesVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [string]$Key = 'version'
    )

    $propertiesData = Read-SemanticReleasePropertiesData -PropertiesPath $Path -Key $Key

    return [pscustomobject]@{
        Path = $Path
        Key = $Key
        Version = $propertiesData.PreviousVersion
    }
}
