# Repository-owned CI wiring; reusable workflow implementation belongs upstream.
BeforeAll {
    $workflowRoot = Join-Path (Split-Path -Parent $PSScriptRoot) '.github/workflows'
    $script:testsCaller = Get-Content -LiteralPath (Join-Path $workflowRoot 'Tests.yml') -Raw
}

Describe 'SemanticRelease reference caller contracts' {
    It 'pins the shared test analyzer to the common required version 1.25.0' {
        $script:testsCaller | Should -Match "(?m)^      script-analyzer-required-version: '1\.25\.0'$"
    }
}
