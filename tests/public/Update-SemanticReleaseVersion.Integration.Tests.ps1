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
        & git -C $script:repoPath config core.hooksPath (Join-Path $script:repoPath '.git/no-hooks')
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

    It 'keeps a breaking change on 0.y.z and warns once from the built module' {
        $jsonPath = Join-Path $script:repoPath 'project.json'
        Set-Content -LiteralPath $jsonPath -Value '{"Version":"0.1.0"}'

        & git -C $script:repoPath add project.json
        & git -C $script:repoPath commit --quiet -m 'feat!: replace public api'

        $result = Update-SemanticReleaseVersion -Path $jsonPath -ProjectRoot $script:repoPath -Confirm:$false -WarningVariable warnings -WarningAction SilentlyContinue

        $result.NewVersion | Should -Be '0.2.0'
        $result.Label | Should -Be 'Major'
        $result.EffectiveLabel | Should -Be 'Minor'
        $warnings | Should -HaveCount 1
    }

    It 'ignores non-version tags when collecting commits since the last release' {
        $jsonPath = Join-Path $script:repoPath 'project.json'
        Set-Content -LiteralPath $jsonPath -Value '{"Version":"1.2.3"}'
        & git -C $script:repoPath add project.json
        & git -C $script:repoPath commit --quiet -m 'chore: release 1.2.3'
        & git -C $script:repoPath tag v1.2.3

        & git -C $script:repoPath commit --quiet --allow-empty -m 'feat!: replace public api'
        & git -C $script:repoPath tag deploy-marker
        & git -C $script:repoPath commit --quiet --allow-empty -m 'fix: correct typo'

        $result = Update-SemanticReleaseVersion -Path $jsonPath -ProjectRoot $script:repoPath -Confirm:$false

        $result.Label | Should -Be 'Major'
        $result.NewVersion | Should -Be '2.0.0'
    }

    It 'leaves the version unchanged when no commits follow the latest version tag' {
        $jsonPath = Join-Path $script:repoPath 'project.json'
        Set-Content -LiteralPath $jsonPath -Value '{"Version":"1.2.3"}'
        & git -C $script:repoPath add project.json
        & git -C $script:repoPath commit --quiet -m 'chore: release 1.2.3'
        & git -C $script:repoPath tag 1.2.3
        $before = Get-Content -LiteralPath $jsonPath -Raw

        $result = Update-SemanticReleaseVersion -Path $jsonPath -ProjectRoot $script:repoPath -Confirm:$false -WarningVariable warnings -WarningAction SilentlyContinue

        $result.NewVersion | Should -Be '1.2.3'
        $result.Applied | Should -BeFalse
        $result.CommitCount | Should -Be 0
        $warnings | Should -HaveCount 1
        Get-Content -LiteralPath $jsonPath -Raw | Should -Be $before
    }

    It 'leaves the version unchanged when the repository has no commits yet' {
        $jsonPath = Join-Path $script:repoPath 'project.json'
        Set-Content -LiteralPath $jsonPath -Value '{"Version":"0.1.0"}'

        $result = Update-SemanticReleaseVersion -Path $jsonPath -ProjectRoot $script:repoPath -Confirm:$false -WarningVariable warnings -WarningAction SilentlyContinue

        $result.NewVersion | Should -Be '0.1.0'
        $result.Applied | Should -BeFalse
        "$warnings" | Should -Match 'initial commit'
    }

    It 'returns the full update result shape under WhatIf without writing' {
        $jsonPath = Join-Path $script:repoPath 'project.json'
        Set-Content -LiteralPath $jsonPath -Value '{"Version":"1.2.3"}'
        & git -C $script:repoPath add project.json
        & git -C $script:repoPath commit --quiet -m 'feat: add release preview'

        $result = Update-SemanticReleaseVersion -Path $jsonPath -ProjectRoot $script:repoPath -WhatIf

        $result.NewVersion | Should -Be '1.3.0'
        $result.Applied | Should -BeFalse
        $result.Label | Should -Be 'Minor'
        $result.EffectiveLabel | Should -Be 'Minor'
        $result.CommitCount | Should -Be 1
        (Get-Content -LiteralPath $jsonPath -Raw | ConvertFrom-Json).Version | Should -Be '1.2.3'
    }
}
