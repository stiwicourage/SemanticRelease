function Update-SemanticReleaseVersion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)][string]$Path,
        [string]$ProjectRoot = (Get-Location).Path,
        [AllowEmptyString()][string]$Key,
        [switch]$Preview
    )

    $context = Get-SemanticReleaseVersionUpdateContext -Path $Path -ProjectRoot $ProjectRoot -Key $Key -PreviewRelease:$Preview
    if (-not $PSCmdlet.ShouldProcess($context.Target, $context.Action)) {
        return $context.WhatIfResult
    }

    return Invoke-SemanticReleaseVersionUpdate -Context $context
}
