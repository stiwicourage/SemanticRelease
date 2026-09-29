BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleaseJsonVersionWriteResult.ps1')
}

Describe 'Get-SemanticReleaseJsonVersionWriteResult' {
    It 'returns a structured write result' {
        $result = Get-SemanticReleaseJsonVersionWriteResult -ChangeInfo @{
            Path = '/tmp/project.json'
            Key = 'Version'
            PreviousVersion = '1.0.0'
            NewVersion = '1.0.1'
        } -Applied

        $result.Path | Should -Be '/tmp/project.json'
        $result.Key | Should -Be 'Version'
        $result.PreviousVersion | Should -Be '1.0.0'
        $result.NewVersion | Should -Be '1.0.1'
        $result.Applied | Should -BeTrue
        $result.Target | Should -Be 'project.json'
    }
}
