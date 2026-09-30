function Write-SemanticReleasePropertiesData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$Data,
        [Parameter(Mandatory)][string]$NewVersion
    )

    $updatedLines = [string[]]$Data.Lines.Clone()
    $updatedLines[$Data.LineIndex] = '{0}{1}{2}' -f $Data.Prefix, $NewVersion, $Data.Suffix
    Set-Content -LiteralPath $Data.Path -Value $updatedLines -Encoding utf8
}
