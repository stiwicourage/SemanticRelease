function Read-SemanticReleasePropertiesData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$PropertiesPath,
        [Parameter(Mandatory)][string]$Key
    )

    $lines = [string[]](Get-Content -LiteralPath $PropertiesPath)
    if ($lines.Count -eq 0) {
        throw "Properties file is empty: $PropertiesPath"
    }

    $propertyData = Find-SemanticReleasePropertyData -Lines $lines -Key $Key
    if ($null -eq $propertyData) {
        throw "Properties key '$Key' was not found in $PropertiesPath"
    }

    return @{
        Path = $PropertiesPath
        Key = $Key
        PreviousVersion = $propertyData.PreviousVersion
        LineIndex = $propertyData.LineIndex
        Prefix = $propertyData.Prefix
        Suffix = $propertyData.Suffix
        Lines = $lines
    }
}

function Find-SemanticReleasePropertyData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$Lines,
        [Parameter(Mandatory)][string]$Key
    )

    $pattern = '^(?<prefix>\s*{0}\s*[:=]\s*)(?<value>.*?)(?<suffix>\s*)$' -f [regex]::Escape($Key)
    for ($index = 0; $index -lt $Lines.Count; $index++) {
        $line = $Lines[$index]
        if ($line -match '^\s*[#!]') {
            continue
        }

        $match = [regex]::Match($line, $pattern)
        if (-not $match.Success) {
            continue
        }

        return @{
            PreviousVersion = $match.Groups['value'].Value.Trim()
            LineIndex = $index
            Prefix = $match.Groups['prefix'].Value
            Suffix = $match.Groups['suffix'].Value
        }
    }
}
