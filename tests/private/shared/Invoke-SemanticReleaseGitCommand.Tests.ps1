BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/shared/Invoke-SemanticReleaseGitCommand.ps1')
}

Describe 'Invoke-SemanticReleaseGitCommand' {
    It 'runs git in the project root and captures exit code and output' {
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid())
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        try {
            $result = Invoke-SemanticReleaseGitCommand -ProjectRoot $tempDir -Arguments @('--version')

            $result.ExitCode | Should -Be 0
            ($result.Output -join ' ') | Should -Match 'git'
        } finally {
            Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
