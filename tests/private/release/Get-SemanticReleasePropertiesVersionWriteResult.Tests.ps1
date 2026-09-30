BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Get-SemanticReleasePropertiesVersionWriteResult.ps1')
}

Describe 'Get-SemanticReleasePropertiesVersionWriteResult' {
    It 'returns the standard version write result payload' {
        $result = Get-SemanticReleasePropertiesVersionWriteResult -ChangeInfo @{
            Path = '/tmp/gradle.properties'
            Key = 'version'
            PreviousVersion = '1.2.3'
            NewVersion = '1.2.4'
        } -Applied

        $result.Path | Should -Be '/tmp/gradle.properties'
        $result.Target | Should -Be 'gradle.properties'
        $result.Key | Should -Be 'version'
        $result.PreviousVersion | Should -Be '1.2.3'
        $result.NewVersion | Should -Be '1.2.4'
        $result.Applied | Should -BeTrue
    }
}
