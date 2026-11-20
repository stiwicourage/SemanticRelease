# Release notes

This file summarizes public cmdlet, CLI, configuration, and migration changes for SemanticRelease.
`CHANGELOG.md` remains the exhaustive record of all changes in each release. **UNRELEASED** changes will be included in the next **stable** release!

## [Unreleased]

### Added

### Changed

- `Get-SemanticReleaseNextVersion` and `Update-SemanticReleaseVersion` keep an exact stable `1.0.0` at `1.0.0` for the first stable release, even when the detected history is fix, feature, or breaking-change based. Preview bumps from exact stable `1.0.0` still move to `1.0.1-preview`.

- Stable bumps on `0.y.z` plan breaking changes as the next minor version instead of `1.0.0` and warn that `1.0.0` must be set manually. Version plans expose the applied label as `EffectiveLabel`.

### Deprecated

### Removed

### Fixed

### Security

## [0.1.0] - 2026-11-11

### Added

- Added the initial reusable `SemanticRelease` PowerShell module core.
- Added public commands for commit-range detection, commit collection, release-label inference, next-version planning, and JSON version updates.
- Added `Update-SemanticReleaseVersion` so repositories can infer stable or preview version bumps from Git commit history without rebuilding that workflow locally.
- Added command help and mirrored automated tests for the initial module surface.
- Added GitHub Actions release automation for stable publishes from `main` and prerelease publishes from `develop`.
- Added the remaining NovaModuleTools-aligned GitHub validation workflows for tests, dependency review, and PSScriptAnalyzer.
