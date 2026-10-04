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
            return Set-SemanticReleaseJsonVersion -Path $Context.Path -Key $Context.Key -Label $Context.Label -ReleaseType $Context.ReleaseType -Confirm:$false
        }
        'Properties' {
            return Set-SemanticReleasePropertiesVersion -Path $Context.Path -Key $Context.Key -Label $Context.Label -ReleaseType $Context.ReleaseType -Confirm:$false
        }
        default {
            throw "Unsupported version update format '$($Context.Format)'."
        }
    }
}

function Get-SemanticReleaseVersionUpdateResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Context,
        [switch]$Applied
    )

    return [pscustomobject]@{
        Path = $Context.Path
        Target = $Context.Target
        Key = $Context.Key
        PreviousVersion = $Context.PreviousVersion
        NewVersion = $Context.NewVersion
        Applied = [bool]$Applied
        Label = $Context.Label
        PreviewRelease = [bool]$Context.PreviewRelease
        CommitMessages = @($Context.CommitMessages)
        CommitCount = $Context.CommitCount
    }
}
