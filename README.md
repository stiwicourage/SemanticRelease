# SemanticRelease

A PowerShell-native semantic release toolkit for automated versioning and release workflows based on Git history and Conventional Commits.

## Initial public commands

The initial module surface provides the reusable semantic-release core for Git-based PowerShell workflows:

- `Get-SemanticReleaseCommitRange` detects the last version tag and returns the commit-range basis.
- `Get-SemanticReleaseCommitMessage` collects commit messages since the last tag, or from the full history when no tag exists.
- `Get-SemanticReleaseLabel` infers the semantic-release label (`Major`, `Minor`, or `Patch`) from commit messages.
- `Get-SemanticReleaseNextVersion` calculates the next semantic version, including preview and stable-release transitions.
- `Set-SemanticReleaseJsonVersion` updates a top-level JSON version key with `ShouldProcess` support.
- `Set-SemanticReleasePropertiesVersion` updates a version property in Java-style `.properties` files such as `gradle.properties`.

Example workflow:

```powershell
$messages = Get-SemanticReleaseCommitMessage
$label = Get-SemanticReleaseLabel -Message $messages
$plan = Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'0.1.0-preview') -Label $label -StableRelease
$result = Set-SemanticReleaseJsonVersion -Path ./project.json -Label $label -Confirm:$false
$gradle = Set-SemanticReleasePropertiesVersion -Path ./gradle.properties -Key version -Label $label -Confirm:$false
```

## GitHub release automation

- `main` is the stable release branch. Pushing a merged release change to `main` runs `.github/workflows/Publish.yml`, publishes the stable module, creates the verified `chore(release): <version>` commit, creates the annotated version tag, and prepares the next prerelease version on `develop`.
- `develop` is the prerelease branch. Run the same workflow with `workflow_dispatch` from `develop` when you want to publish the current prerelease and bump `develop` to the next preview version.
- The workflow expects the repository secret `PSGALLERY_API` so GitHub Actions can publish to PSGallery.

## GitHub validation workflows

- `.github/workflows/Tests.yml` mirrors the NovaModuleTools CI flow for build, unit tests, integration tests, artifacts, and optional CodeScene upload when the required GitHub variables and secrets are configured.
- `.github/workflows/powershell.yml` uploads SARIF results from `PSScriptAnalyzer`.
- `.github/workflows/dependency-review.yml` runs GitHub dependency review on pull requests to `develop`.

## Agentic Copilot workflow

Follow this workflow when working with Copilot in this repository.

1. **Design**
    - Start with `/agent architect`, `.github/agents/architect.agent.md`, and `.github/prompts/design-change.prompt.md` to scope the change before implementation.
2. **Implement**
    - Use `/agent powershell-developer`, `.github/agents/powershell-developer.agent.md`, and `.github/prompts/implement-issue.prompt.md` when the change is already scoped.
    - If the work is mainly about tests or coverage, use `/agent test-engineer`, `.github/agents/test-engineer.agent.md`, and `.github/prompts/improve-test-coverage.prompt.md`.
3. **Review**
    - Use `/agent reviewer`, `.github/agents/reviewer.agent.md`, and `.github/prompts/review-change.prompt.md` before handoff or pull request review.
4. **Prepare release**
    - Use `/agent release-manager`, `.github/agents/release-manager.agent.md`, and `.github/prompts/prepare-release.prompt.md` when preparing the pull request summary and release-facing follow-up.

## Nova project expectations

- Use Nova commands and `project.json` for build, test, package, and release behavior.
- Treat `project.json` `Manifest.PowerShellHostVersion` as the compatibility target for PowerShell code, tests, and examples. If it is `5.1`, do not introduce PowerShell 7.x-only features.
- Keep local quality checks ordered as ScriptAnalyzer first, then `Invoke-NovaBuild`, then `Invoke-NovaTest`, then `Test-NovaBuild` when your project defines both test flows.
- Use `Invoke-NovaTest` for unit validation and `Test-NovaBuild` for build-validation integration runs. Do not validate with direct `Invoke-Pester`, because it can bypass Nova's build/import/StrictMode flow and disagree with later user-visible test runs.
- Keep public command unit coverage in `tests/public/<Command>.Tests.ps1` and keep per-command integration ownership in `tests/public/<Command>.Integration.Tests.ps1` when built-module behavior itself needs validation.
- For destructive or environment-coupled public commands, prefer safe `-WhatIf` integration coverage when that still proves `ShouldProcess` wiring and command behavior.
- If the repository quality loop or `Invoke-ScriptAnalyzerCI.ps1` reports ScriptAnalyzer findings, fix them before review or handoff.
- Follow `.github/instructions/psscriptanalyzer.instructions.md` as the ScriptAnalyzer workflow source of truth. Prefer `./scripts/build/Invoke-ScriptAnalyzerCI.ps1` and the repository quality loop, when present, and use direct `Invoke-ScriptAnalyzer` only for focused local checks that reuse the repo-approved settings.
- Keep one externally called function per file and match the file name to that function. Public files own one command each; private files may keep extra related functions only as same-file top-level support helpers, and PowerShell functions must not declare nested functions inside their bodies.
- Follow `.github/instructions/code-quality-matrix.instructions.md` as the best-effort maintainability guidance for source/helper scripts, and `.github/instructions/testing-policy.instructions.md` for test design. These guide agents and reviewers in this generated project.
- Generate valid PlatyPS help under `docs/SemanticRelease/en-US/` whenever command help changes. Use `New-MarkdownCommandHelp`, `Update-MarkdownCommandHelp`, and `Test-MarkdownCommandHelp` instead of hand-writing the help structure.
- Every new public entry point must add its matching help file in the same change.
- Make every changed or generated text file end immediately after exactly one newline terminator; do not leave a blank spacer line at the bottom. Use `pwsh -NoLogo -NoProfile -File ./scripts/build/Test-TextFileFormatting.ps1` for a focused check, and keep `tests/TextFileFormatting.Tests.ps1` passing when the project uses Pester.
- Do not exclude or suppress PSScriptAnalyzer rules; fix analyzer findings in the code.
- Do not hand-create module `.psm1` or module `.psd1` files in source; Nova generates them under `dist/SemanticRelease/`.
- Add PlatyPS-compatible help under `docs/SemanticRelease/en-US/` when public commands or public classes change.
- Keep tests mirrored to source files: every new or changed `src/**/*.ps1` file should have one focused `.Tests.ps1` file, for example `src/private/foo/Get-Thing.ps1` -> `tests/private/foo/Get-Thing.Tests.ps1`.
- For public commands, the mirrored unit-test owner is `tests/public/<Command>.Tests.ps1`; add `tests/public/<Command>.Integration.Tests.ps1` when the built public command behavior itself needs integration coverage.
- Put shared test setup in `tests/TestHelpers/` or a test-support file instead of grouping unrelated source coverage into broad catch-all tests.

## Start here

Use this repository as the starting point for your module.

- Review `README.md`, `CONTRIBUTING.md`, and `.github/copilot-instructions.md`.
- Use `Invoke-NovaBuild` / `% nova build` to produce the first local build.
- Use `Invoke-NovaTest` / `% nova test` for unit tests and `Test-NovaBuild` / `% nova test --build` for build-validation integration tests before opening a pull request.
