# Changelog

All notable changes to this project will be documented in this file and **UNRELEASED** changes will be included in the next **stable** release!

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

- `Get-SemanticReleaseNextVersion` and `Update-SemanticReleaseVersion` now preserve an exact stable `1.0.0` as the first stable release target instead of auto-advancing it from inferred fix, feature, or breaking-change history.
    - The detected semantic label is still reported, but the next stable release stays `1.0.0`.
    - Preview bumps from exact stable `1.0.0` still enter the next patch preview track as `1.0.1-preview`.

- Stable bumps on `0.y.z` now keep breaking changes on the initial-development line: a `Major` label is planned as the next minor version instead of `1.0.0`, matching NovaModuleTools.
    - The detected `Major` label is still reported, the new `EffectiveLabel` plan property shows `Minor`, and a warning explains that `1.0.0` must be set manually once the software is stable.
    - Preview bumps are not remapped by this rule, and major bumps from `1.y.z` and later are unchanged.

### Deprecated

### Removed

### Fixed

### Security

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
