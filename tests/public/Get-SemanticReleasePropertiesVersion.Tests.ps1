BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    . (Join-Path $projectRoot 'src/public/Get-SemanticReleasePropertiesVersion.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleasePropertiesData.ps1')
}

Describe 'Get-SemanticReleasePropertiesVersion' {
    BeforeEach {
        $script:propertiesPath = Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString('N') + '.properties')
    }

    AfterEach {
        Remove-Item -LiteralPath $script:propertiesPath -ErrorAction SilentlyContinue
    }

    It 'returns the current version and leaves the file unchanged' {
        Set-Content -LiteralPath $script:propertiesPath -Value @('pluginName=demo', 'version=1.2.3-preview01')
        $before = Get-Content -LiteralPath $script:propertiesPath -Raw

        $result = Get-SemanticReleasePropertiesVersion -Path $script:propertiesPath

        $result.Version | Should -Be '1.2.3-preview01'
        $result.Key | Should -Be 'version'
        $result.Path | Should -Be $script:propertiesPath
        Get-Content -LiteralPath $script:propertiesPath -Raw | Should -Be $before
    }

    It 'reads a custom key using the colon syntax' {
        Set-Content -LiteralPath $script:propertiesPath -Value @('pluginVersion : 4.5.6')

        $result = Get-SemanticReleasePropertiesVersion -Path $script:propertiesPath -Key pluginVersion

        $result.Version | Should -Be '4.5.6'
    }

    It 'throws when the key is missing' {
        Set-Content -LiteralPath $script:propertiesPath -Value @('other=1')

        { Get-SemanticReleasePropertiesVersion -Path $script:propertiesPath } | Should -Throw "*was not found*"
    }
}
