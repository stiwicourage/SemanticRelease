---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 09.29.2026
PlatyPS schema version: 2024-05-01
title: Get-SemanticReleaseCommitRange
---

# Get-SemanticReleaseCommitRange

## SYNOPSIS

Detects the last version tag in a Git repository and returns the commit-range basis for semantic release calculations.

## SYNTAX

### __AllParameterSets

```
Get-SemanticReleaseCommitRange [[-ProjectRoot] <string>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to determine whether the target path is a Git repository, whether a version tag is present, and which revision range should be used for release analysis.

When a tag is found, the cmdlet returns the exact `tag..HEAD` range used by the release helpers.
When no tag is found, the cmdlet reports repository scope without a revision range so downstream commands can evaluate the full history.

## EXAMPLES

### Example 1

Detect the current semantic-release range for the repository in the working directory.

```powershell
PS> Get-SemanticReleaseCommitRange

ProjectRoot    : /Users/example/SemanticRelease
IsRepository   : True
HasVersionTag  : True
LastTag        : v1.2.3
RevisionRange  : v1.2.3..HEAD
```

## PARAMETERS

### -ProjectRoot

Specifies the repository root to inspect. The default value is the current working directory.

```yaml
Type: System.String
DefaultValue: (Get-Location).Path
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

Returns a range-basis object with `ProjectRoot`, `IsRepository`, `HasVersionTag`, `LastTag`, and `RevisionRange` properties.

## NOTES

- The cmdlet uses `git describe --tags --abbrev=0` to locate the most recent version tag.
- If Git is unavailable or the path is not a repository, `IsRepository` is `$false`.

## RELATED LINKS

- [Get-SemanticReleaseCommitMessage](./Get-SemanticReleaseCommitMessage.md)
- [Get-SemanticReleaseLabel](./Get-SemanticReleaseLabel.md)
