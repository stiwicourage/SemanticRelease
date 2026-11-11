BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Import-Module (Join-Path $projectRoot 'dist/SemanticRelease/SemanticRelease.psd1') -Force
}

Describe 'Get-SemanticReleasePropertiesVersion integration' {
    It 'reads the version from a properties file when called from the built module' {
        $propertiesPath = Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString('N') + '.properties')
        Set-Content -LiteralPath $propertiesPath -Value @('pluginName=demo', 'version=1.2.3')

        try {
            (Get-SemanticReleasePropertiesVersion -Path $propertiesPath).Version | Should -Be '1.2.3'
        }
        finally {
            Remove-Item -LiteralPath $propertiesPath -ErrorAction SilentlyContinue
        }
    }
}
