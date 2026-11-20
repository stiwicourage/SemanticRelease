---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 09.29.2026
PlatyPS schema version: 2024-05-01
title: Get-SemanticReleaseNextVersion
---

# Get-SemanticReleaseNextVersion

## SYNOPSIS

Calculates the next semantic version from a current version and release label.

## SYNTAX

### __AllParameterSets

```
Get-SemanticReleaseNextVersion [-CurrentVersion] <semver> [[-Label] <string>] [-Preview]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to build the next semantic version plan for stable or preview releases. Plans are stable by default; use `-Preview` for a preview release.

When the current version is on `0.y.z` and the label is `Major`, stable plans keep the release on the initial-development line and plan the next minor version instead of jumping to `1.0.0`. The plan still reports the detected `Major` label, sets `EffectiveLabel` to `Minor`, and writes a warning about setting `1.0.0` manually once the software is stable. Preview plans are not remapped by this rule.

When the current stable version is exactly `1.0.0`, it is treated as the manually selected first stable release target: fix, feature, and breaking-change labels still apply, but the planned stable version stays `1.0.0`. With `-Preview`, it still enters the next patch preview track (`1.0.1-preview`).

Stable releases increment the requested version part, except when finalizing an existing prerelease for the same target label.
Preview releases preserve existing prerelease targets and increment the preview label, or start a new preview from the next patch version when the current version is stable.

## EXAMPLES

### Example 1

Calculate the next stable minor release.

```powershell
PS> Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3') -Label Minor

CurrentVersion : 1.2.3
Label          : Minor
EffectiveLabel : Minor
PreviewRelease : False
NewVersion     : 1.3.0
```

### Example 2

Continue an existing preview release without changing the version parts.

```powershell
PS> Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3-preview01') -Label Patch -Preview

CurrentVersion : 1.2.3-preview01
Label          : Patch
EffectiveLabel : Patch
PreviewRelease : True
NewVersion     : 1.2.3-preview02
```

### Example 3

Keep a breaking change on the initial-development line.

```powershell
PS> Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'0.1.0') -Label Major

WARNING: Major version zero (0.y.z) is for initial development, so SemanticRelease plans this breaking change as the next minor version instead of 1.0.0. Set 1.0.0 manually once the software is stable; after that, automatic major-version bumps work normally.

CurrentVersion : 0.1.0
Label          : Major
EffectiveLabel : Minor
PreviewRelease : False
NewVersion     : 0.2.0
```

## PARAMETERS

### -CurrentVersion

Specifies the current semantic version.

```yaml
Type: System.Management.Automation.SemanticVersion
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Label

Specifies which semantic version part to target. Valid values are `Major`, `Minor`, and `Patch`.

```yaml
Type: System.String
DefaultValue: Patch
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Preview

Indicates that the next version should be a preview release. Without this switch, the plan is a stable release. The `PreviewRelease` alias is kept for existing pipelines.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- PreviewRelease
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject

Returns a version-plan object with `CurrentVersion`, `Label`, `EffectiveLabel`, `PreviewRelease`, and `NewVersion` properties.

## NOTES

- Version construction uses `[semver]::new(major, minor, patch, releaseType, $null)`.
- Preview numbering starts at `preview01` and preserves zero-padding width on multi-digit suffixes.

## RELATED LINKS

- [Get-SemanticReleaseLabel](./Get-SemanticReleaseLabel.md)
- [Set-SemanticReleaseJsonVersion](./Set-SemanticReleaseJsonVersion.md)
