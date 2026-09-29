function Invoke-SemanticReleaseGitCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ProjectRoot,
        [Parameter(Mandatory)][string[]]$Arguments
    )

    $output = & git -C $ProjectRoot @Arguments 2> $null
    return [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Output = @($output)
    }
}
