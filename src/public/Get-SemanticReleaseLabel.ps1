function Get-SemanticReleaseLabel {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()][string[]]$Message = @()
    )

    return Resolve-SemanticReleaseVersionLabel -Message $Message
}
