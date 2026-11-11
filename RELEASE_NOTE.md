# Release notes

This file summarizes public cmdlet, CLI, configuration, and migration changes for SemanticRelease.
`CHANGELOG.md` remains the exhaustive record of all changes in each release. **UNRELEASED** changes will be included in the next **stable** release!

## [Unreleased]

### Added

- Added the initial reusable `SemanticRelease` PowerShell module core.
- Added public commands for commit-range detection, commit collection, release-label inference, next-version planning, and JSON version updates.
- Added `Update-SemanticReleaseVersion` so repositories can infer stable or preview version bumps from Git commit history without rebuilding that workflow locally.
- Added command help and mirrored automated tests for the initial module surface.
- Added GitHub Actions release automation for stable publishes from `main` and prerelease publishes from `develop`.
- Added the remaining NovaModuleTools-aligned GitHub validation workflows for tests, dependency review, and PSScriptAnalyzer.

### Changed

### Deprecated

### Removed

### Fixed

### Security
