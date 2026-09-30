BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Import-Module (Join-Path $projectRoot 'dist/SemanticRelease/SemanticRelease.psd1') -Force
}

Describe 'Set-SemanticReleasePropertiesVersion integration' {
    BeforeEach {
        $script:propertiesPath = Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString('N') + '.properties')
        Set-Content -LiteralPath $script:propertiesPath -Value @(
            'pluginName=azure-devops-comments'
            'version=1.2.3'
        )
    }

    AfterEach {
        Remove-Item -LiteralPath $script:propertiesPath -ErrorAction SilentlyContinue
    }

    It 'respects WhatIf when called from the built module' {
        $result = Set-SemanticReleasePropertiesVersion -Path $script:propertiesPath -WhatIf
        $content = Get-Content -LiteralPath $script:propertiesPath -Raw

        $result.Applied | Should -BeFalse
        $content | Should -Match 'version=1.2.3'
    }

    It 'updates the properties file when called from the built module' {
        $result = Set-SemanticReleasePropertiesVersion -Path $script:propertiesPath -Label Minor -Confirm:$false
        $content = Get-Content -LiteralPath $script:propertiesPath -Raw

        $result.NewVersion | Should -Be '1.3.0'
        $result.Applied | Should -BeTrue
        $content | Should -Match 'version=1.3.0'
    }
}
