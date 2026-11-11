# Changelog

All notable changes to this project will be documented in this file and **UNRELEASED** changes will be included in the next **stable** release!

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

### Deprecated

### Removed

### Fixed

### Security
