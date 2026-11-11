BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleasePropertiesData.ps1')
}

Describe 'Read-SemanticReleasePropertiesData' {
    BeforeEach {
        $script:file = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [Guid]::NewGuid().ToString('N') + '.properties')
    }

    AfterEach {
        Remove-Item -LiteralPath $script:file -ErrorAction SilentlyContinue
    }

    It 'returns the matching property context for equals syntax' {
        Set-Content -LiteralPath $script:file -Value @(
            '# comment'
            'version = 1.2.3'
        )

        $result = Read-SemanticReleasePropertiesData -PropertiesPath $script:file -Key 'version'

        $result.PreviousVersion | Should -Be '1.2.3'
        $result.LineIndex | Should -Be 1
        $result.Prefix | Should -Be 'version = '
    }

    It 'returns the matching property context for colon syntax' {
        Set-Content -LiteralPath $script:file -Value 'version:1.2.3'

        $result = Read-SemanticReleasePropertiesData -PropertiesPath $script:file -Key 'version'

        $result.PreviousVersion | Should -Be '1.2.3'
        $result.Prefix | Should -Be 'version:'
    }

    It 'throws when the key is missing' {
        Set-Content -LiteralPath $script:file -Value 'pluginName=demo'

        { Read-SemanticReleasePropertiesData -PropertiesPath $script:file -Key 'version' } | Should -Throw
    }
}
