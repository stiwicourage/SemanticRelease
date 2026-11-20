function Resolve-SemanticReleaseVersionLabel {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()][string[]]$Message = @()
    )

    if ($Message | Where-Object { Test-SemanticReleaseBreakingChangeMessage -Message $_ }) {
        return 'Major'
    }

    if ($Message | Where-Object { $_ -match '(?im)^\s*feat(\(.+\))?:' }) {
        return 'Minor'
    }

    if ($Message | Where-Object { $_ -match '(?im)^\s*fix(\(.+\))?:' }) {
        return 'Patch'
    }

    return 'Patch'
}

function Test-SemanticReleaseBreakingChangeMessage {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [AllowEmptyString()][string]$Message
    )

    # Conventional Commits footer tokens are case-sensitive and must start a line.
    if ($Message -cmatch '(?m)^BREAKING[ -]CHANGE:') {
        return $true
    }

    return $Message -match '(?im)^\s*[a-z]+(\(.+\))?!:'
}
