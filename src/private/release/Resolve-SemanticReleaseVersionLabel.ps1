function Resolve-SemanticReleaseVersionLabel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$Message
    )

    if ($Message | Where-Object { $_ -match '(?im)BREAKING CHANGE|^[a-z]+(\(.+\))?!:' }) {
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
