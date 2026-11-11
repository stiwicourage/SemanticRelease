BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/shared/Write-SemanticReleasePropertiesData.ps1')
}

Describe 'Write-SemanticReleasePropertiesData' {
    BeforeEach {
        $script:tempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [Guid]::NewGuid().ToString('N') + '.properties')
    }

    AfterEach {
        Remove-Item -LiteralPath $script:tempFile -ErrorAction SilentlyContinue
    }

    It 'updates the requested line and keeps unrelated lines' {
        $data = @{
            Path = $script:tempFile
            Key = 'version'
            LineIndex = 1
            Prefix = 'version='
            Suffix = ''
            Lines = @(
                'pluginName=demo'
                'version=1.2.3'
                'kotlin.stdlib.default.dependency=false'
            )
        }

        Write-SemanticReleasePropertiesData -Data $data -NewVersion '1.2.4'

        $content = Get-Content -LiteralPath $script:tempFile
        $content[0] | Should -Be 'pluginName=demo'
        $content[1] | Should -Be 'version=1.2.4'
        $content[2] | Should -Be 'kotlin.stdlib.default.dependency=false'
    }
}
