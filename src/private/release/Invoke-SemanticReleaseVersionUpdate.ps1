function Invoke-SemanticReleaseVersionUpdate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Context
    )

    $writerResult = Invoke-SemanticReleaseVersionWriter -Context $Context
    return Get-SemanticReleaseVersionUpdateResult -Context $Context -Applied:$writerResult.Applied
}

function Invoke-SemanticReleaseVersionWriter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Context
    )

    switch ($Context.Format) {
        'Json' {
            return Set-SemanticReleaseJsonVersion -Path $Context.Path -Key $Context.Key -Label $Context.EffectiveLabel -Preview:$Context.PreviewRelease -Confirm:$false
        }
        'Properties' {
            return Set-SemanticReleasePropertiesVersion -Path $Context.Path -Key $Context.Key -Label $Context.EffectiveLabel -Preview:$Context.PreviewRelease -Confirm:$false
        }
        default {
            throw "Unsupported version update format '$($Context.Format)'."
        }
    }
}
