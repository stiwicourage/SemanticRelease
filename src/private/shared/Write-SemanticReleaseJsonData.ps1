function Write-SemanticReleaseJsonData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$JsonPath,
        [Parameter(Mandatory)][hashtable]$Data
    )

    $jsonContent = $Data | ConvertTo-Json -Depth 20
    Set-Content -LiteralPath $JsonPath -Value $jsonContent -Encoding utf8
}
