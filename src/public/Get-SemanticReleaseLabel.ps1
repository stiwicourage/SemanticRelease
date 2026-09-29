function Get-SemanticReleaseLabel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$Message
    )

    return Resolve-SemanticReleaseVersionLabel -Message $Message
}
