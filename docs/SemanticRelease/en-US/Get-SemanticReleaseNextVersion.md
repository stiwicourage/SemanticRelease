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
Get-SemanticReleaseNextVersion [-CurrentVersion] <semver> [[-Label] <string>] [-PreviewRelease]
 [-StableRelease]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to build the next semantic version plan for stable or preview releases.

Stable releases increment the requested version part, except when finalizing an existing prerelease for the same target label.
Preview releases preserve existing prerelease targets and increment the preview label, or start a new preview from the next patch version when the current version is stable.

## EXAMPLES

### Example 1

Calculate the next stable minor release.

```powershell
PS> Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3') -Label Minor

CurrentVersion : 1.2.3
Label          : Minor
PreviewRelease : False
StableRelease  : False
NewVersion     : 1.3.0
```

### Example 2

Continue an existing preview release without changing the version parts.

```powershell
PS> Get-SemanticReleaseNextVersion -CurrentVersion ([semver]'1.2.3-preview01') -Label Patch -PreviewRelease

CurrentVersion : 1.2.3-preview01
Label          : Patch
PreviewRelease : True
StableRelease  : False
NewVersion     : 1.2.3-preview02
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

### -PreviewRelease

Indicates that the next version should be a preview release.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -StableRelease

Indicates that the next version should be emitted without a prerelease label.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

Returns a version-plan object with `CurrentVersion`, `Label`, `PreviewRelease`, `StableRelease`, and `NewVersion` properties.

## NOTES

- Version construction uses `[semver]::new(major, minor, patch, releaseType, $null)`.
- Preview numbering starts at `preview01` and preserves zero-padding width on multi-digit suffixes.

## RELATED LINKS

- [Get-SemanticReleaseLabel](./Get-SemanticReleaseLabel.md)
- [Set-SemanticReleaseJsonVersion](./Set-SemanticReleaseJsonVersion.md)
