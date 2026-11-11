function Read-SemanticReleaseJsonData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$JsonPath
    )

    $jsonContent = Get-Content -LiteralPath $JsonPath -Raw
    if ([string]::IsNullOrWhiteSpace($jsonContent)) {
        throw "JSON file is empty: $JsonPath"
    }

    try {
        $jsonData = $jsonContent | ConvertFrom-Json -AsHashtable
    } catch {
        throw "JSON file is not valid JSON: $JsonPath. $( $_.Exception.Message )"
    }

    if ($jsonData -isnot [hashtable]) {
        throw "JSON file must contain a top-level JSON object: $JsonPath"
    }

    return $jsonData
}
