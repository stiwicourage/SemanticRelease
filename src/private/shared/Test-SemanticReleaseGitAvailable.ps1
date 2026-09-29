function Test-SemanticReleaseGitAvailable {
    [CmdletBinding()]
    param()

    return $null -ne (Get-Command -Name 'git' -ErrorAction SilentlyContinue)
}
