BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Resolve-SemanticReleasePreReleaseLabel.ps1')
}

Describe 'Get-SemanticReleaseInitialPreReleaseNumber' {
    It 'returns 01' {
        Get-SemanticReleaseInitialPreReleaseNumber | Should -Be '01'
    }
}

Describe 'Get-SemanticReleaseIncrementedPreReleaseNumber' {
    It 'increments single-digit labels without padding' {
        Get-SemanticReleaseIncrementedPreReleaseNumber -PreReleaseNumber '3' | Should -Be 4
    }

    It 'pads zero-padded numbers to the same width' {
        Get-SemanticReleaseIncrementedPreReleaseNumber -PreReleaseNumber '09' | Should -Be '10'
    }
}

Describe 'Get-SemanticReleaseNextPreReleaseLabel' {
    It 'appends the initial number when no number suffix exists' {
        Get-SemanticReleaseNextPreReleaseLabel -PreReleaseLabel 'preview' | Should -Be 'preview01'
    }

    It 'increments the existing numeric suffix' {
        Get-SemanticReleaseNextPreReleaseLabel -PreReleaseLabel 'preview01' | Should -Be 'preview02'
    }
}

Describe 'Resolve-SemanticReleasePreviewLabel' {
    It 'returns preview when the current version is null' {
        Resolve-SemanticReleasePreviewLabel -CurrentVersion $null | Should -Be 'preview'
    }

    It 'returns preview when the current version has no prerelease label' {
        Resolve-SemanticReleasePreviewLabel -CurrentVersion ([semver]'1.2.3') | Should -Be 'preview'
    }

    It 'returns the next preview label when one exists' {
        Resolve-SemanticReleasePreviewLabel -CurrentVersion ([semver]'1.2.3-preview01') | Should -Be 'preview02'
    }
}

Describe 'Resolve-SemanticReleasePreReleaseLabel' {
    It 'returns preview for preview releases' {
        Resolve-SemanticReleasePreReleaseLabel -CurrentVersion ([semver]'1.0.0') -PreviewRelease | Should -Be 'preview'
    }

    It 'returns null for stable releases' {
        Resolve-SemanticReleasePreReleaseLabel -CurrentVersion ([semver]'1.0.0') -StableRelease | Should -BeNullOrEmpty
    }

    It 'returns null by default' {
        Resolve-SemanticReleasePreReleaseLabel -CurrentVersion ([semver]'1.0.0') | Should -BeNullOrEmpty
    }
}
