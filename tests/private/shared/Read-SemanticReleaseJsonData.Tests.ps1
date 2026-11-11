BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/shared/Read-SemanticReleaseJsonData.ps1')
}

Describe 'Read-SemanticReleaseJsonData' {
    BeforeEach {
        $script:file = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [Guid]::NewGuid().ToString('N') + '.json')
    }

    AfterEach {
        Remove-Item -LiteralPath $script:file -ErrorAction SilentlyContinue
    }

    It 'returns a hashtable for valid JSON' {
        Set-Content -LiteralPath $script:file -Value '{"Name": "Demo", "Version": "1.0"}'

        $result = Read-SemanticReleaseJsonData -JsonPath $script:file

        $result | Should -BeOfType [hashtable]
        $result.Name | Should -Be 'Demo'
        $result.Version | Should -Be '1.0'
    }

    It 'throws when the file is empty' {
        Set-Content -LiteralPath $script:file -Value ''

        { Read-SemanticReleaseJsonData -JsonPath $script:file } | Should -Throw
    }

    It 'throws when the JSON is invalid' {
        Set-Content -LiteralPath $script:file -Value '{not json}'

        { Read-SemanticReleaseJsonData -JsonPath $script:file } | Should -Throw
    }

    It 'throws when the JSON is not a top-level object' {
        Set-Content -LiteralPath $script:file -Value '[1, 2, 3]'

        { Read-SemanticReleaseJsonData -JsonPath $script:file } | Should -Throw
    }
}
