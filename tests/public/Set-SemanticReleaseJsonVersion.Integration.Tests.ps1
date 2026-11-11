BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Import-Module (Join-Path $projectRoot 'dist/SemanticRelease/SemanticRelease.psd1') -Force
}

Describe 'Set-SemanticReleaseJsonVersion integration' {
    BeforeEach {
        $script:jsonPath = Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString('N') + '.json')
        Set-Content -LiteralPath $script:jsonPath -Value '{"Version":"1.2.3"}'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:jsonPath -ErrorAction SilentlyContinue
    }

    It 'respects WhatIf when called from the built module' {
        $result = Set-SemanticReleaseJsonVersion -Path $script:jsonPath -WhatIf
        $content = Get-Content -LiteralPath $script:jsonPath -Raw | ConvertFrom-Json

        $result.Applied | Should -BeFalse
        $content.Version | Should -Be '1.2.3'
    }

    It 'updates the JSON file when called from the built module' {
        $result = Set-SemanticReleaseJsonVersion -Path $script:jsonPath -Label Minor -Confirm:$false
        $content = Get-Content -LiteralPath $script:jsonPath -Raw | ConvertFrom-Json

        $result.NewVersion | Should -Be '1.3.0'
        $result.Applied | Should -BeTrue
        $content.Version | Should -Be '1.3.0'
    }
}
