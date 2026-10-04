BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Import-Module (Join-Path $projectRoot 'dist/SemanticRelease/SemanticRelease.psd1') -Force
}

Describe 'Update-SemanticReleaseVersion integration' {
    BeforeEach {
        $script:repoPath = Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $script:repoPath

        & git -C $script:repoPath init --quiet | Out-Null
        & git -C $script:repoPath config user.email 'semanticrelease@example.com'
        & git -C $script:repoPath config user.name 'Semantic Release Tests'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:repoPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'updates preview properties versions from the built module' {
        $propertiesPath = Join-Path $script:repoPath 'gradle.properties'
        Set-Content -LiteralPath $propertiesPath -Value @(
            'pluginName=azure-devops-comments'
            'version=1.2.3-preview01'
        )

        & git -C $script:repoPath add gradle.properties
        & git -C $script:repoPath commit --quiet -m 'feat: publish preview update'

        $result = Update-SemanticReleaseVersion -Path $propertiesPath -ProjectRoot $script:repoPath -Preview -Confirm:$false
        $content = Get-Content -LiteralPath $propertiesPath -Raw

        $result.NewVersion | Should -Be '1.2.3-preview02'
        $result.Applied | Should -BeTrue
        $content | Should -Match 'version=1.2.3-preview02'
    }

    It 'updates JSON versions from the built module' {
        $jsonPath = Join-Path $script:repoPath 'project.json'
        Set-Content -LiteralPath $jsonPath -Value '{"Version":"1.2.3"}'

        & git -C $script:repoPath add project.json
        & git -C $script:repoPath commit --quiet -m 'fix: correct release workflow'

        $result = Update-SemanticReleaseVersion -Path $jsonPath -ProjectRoot $script:repoPath -Confirm:$false
        $content = Get-Content -LiteralPath $jsonPath -Raw | ConvertFrom-Json

        $result.NewVersion | Should -Be '1.2.4'
        $result.Applied | Should -BeTrue
        $content.Version | Should -Be '1.2.4'
    }
}
