# Changelog

All notable changes to this project will be documented in this file and **UNRELEASED** changes will be included in the next **stable** release!

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [0.3.1] - 2026-11-22

## [0.3.0] - 2026-11-22

### Changed

- `./scripts/build/Invoke-ScriptAnalyzerCI.ps1` now delegates to the shared `powershell-ci` analyzer with the CI settings, so local runs analyze `src/`, `scripts/`, `tests/`, and `run.ps1` like CI and fail on every severity, including `Information`. It needs a `powershell-ci` checkout next to the repository or `POWERSHELL_CI_PATH`.
- CI now uses the shared `powershell-ci` workflows from release `0.5.0` instead of `0.1.1`.
- Dependabot now checks GitHub Actions daily and proposes new `powershell-ci` tags without the default release cooldown.

### Removed

- The local ScriptAnalyzer wrapper's `-IncludeTests` switch. Tests are always analyzed.

## [0.2.0] - 2026-11-20

### Changed

- Breaking: all version commands now select the release mode with one `-Preview` switch, matching NovaModuleTools. Stable is the default.
    - `Set-SemanticReleaseJsonVersion` and `Set-SemanticReleasePropertiesVersion` replace `-ReleaseType Default|Preview|Stable` with `-Preview`.
    - `Get-SemanticReleaseNextVersion` replaces `-PreviewRelease` and `-StableRelease` with `-Preview`.
    - Version plans no longer include the `StableRelease` property.

- `Update-SemanticReleaseVersion` leaves the version file unchanged when the repository has no commits since the latest version tag, or no commits at all.
    - It writes one warning and returns `Applied = False` with `NewVersion` equal to `PreviousVersion`, so re-running a release workflow does not bump the version.
    - Outside a Git repository, it still falls back to a `Patch` bump.

- `Update-SemanticReleaseVersion -WhatIf` now returns the same result shape as a real run, including `Label`, `EffectiveLabel`, `PreviewRelease`, `CommitMessages`, and `CommitCount`, with `Applied = False`.

- `Get-SemanticReleaseNextVersion` and `Update-SemanticReleaseVersion` now preserve an exact stable `1.0.0` as the first stable release target instead of auto-advancing it from inferred fix, feature, or breaking-change history.
    - The detected semantic label is still reported, but the next stable release stays `1.0.0`.
    - Preview bumps from exact stable `1.0.0` still enter the next patch preview track as `1.0.1-preview`.

- Stable bumps on `0.y.z` now keep breaking changes on the initial-development line: a `Major` label is planned as the next minor version instead of `1.0.0`, matching NovaModuleTools.
    - The detected `Major` label is still reported, the new `EffectiveLabel` property on version plans and `Update-SemanticReleaseVersion` results shows `Minor`, and a warning explains that `1.0.0` must be set manually once the software is stable.
    - Preview bumps are not remapped by this rule, and major bumps from `1.y.z` and later are unchanged.

### Fixed

- Breaking-change detection now follows the Conventional Commits specification: `BREAKING CHANGE:` and `BREAKING-CHANGE:` footers must be uppercase and start a line. Prose such as `docs: explain why this is not a breaking change` no longer triggers a major bump.
- Commit-range detection only uses tags that look like semantic versions, such as `1.2.3` or `v1.2.3`. Other tags, such as `deploy-marker`, no longer hide earlier commits from the release-label calculation.

## [0.1.0] - 2026-11-11

### Added

- Initial `SemanticRelease` module core with reusable Git commit-range discovery, commit collection, release-label inference, semantic-version planning, and JSON version updates.
- Added `Set-SemanticReleasePropertiesVersion` for commit-driven updates of Java-style `.properties` version keys such as `gradle.properties`.
- Added `Get-SemanticReleasePropertiesVersion` to read the current version from a Java-style `.properties` file such as `gradle.properties` without modifying it.
- Added `Update-SemanticReleaseVersion` to infer stable or preview version bumps from Git commit history and apply them directly to JSON or `.properties` version files.
- Source-mirrored Pester coverage for the new public commands and private release/shared helpers.
- PlatyPS command help for the initial public module surface under `docs/SemanticRelease/en-US/`.
- GitHub publish automation mirrored from NovaModuleTools, including verified release commits/tags on `main` and prerelease preparation on `develop`.
- GitHub test, dependency-review, PSScriptAnalyzer, and optional CodeScene workflows mirrored from NovaModuleTools for branch validation and CI artifacts.

### Changed

- GitHub workflows now call the shared `stiwicourage/powershell-ci` reusable workflows instead of local copies; the local `.github/actions/` and `scripts/build/ci/` helpers, `powershell.yml` and `dependency-review.yml` were replaced by `Security.yml` (adds CodeQL), and the scheduled test run is now daily.

[Unreleased]: https://github.com/stiwicourage/SemanticRelease/compare/0.3.1...HEAD
[0.3.1]: https://github.com/stiwicourage/SemanticRelease/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/stiwicourage/SemanticRelease/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/stiwicourage/SemanticRelease/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/stiwicourage/SemanticRelease/releases/tag/0.1.0
