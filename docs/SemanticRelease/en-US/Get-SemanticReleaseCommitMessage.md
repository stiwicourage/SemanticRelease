---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 09.29.2026
PlatyPS schema version: 2024-05-01
title: Get-SemanticReleaseCommitMessage
---

# Get-SemanticReleaseCommitMessage

## SYNOPSIS

Collects Git commit messages for semantic-release analysis.

## SYNTAX

### __AllParameterSets

```
Get-SemanticReleaseCommitMessage [[-ProjectRoot] <string>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to read commit messages from the target Git repository using the semantic-release log format `%s%n%b%n--END-COMMIT--`.

If a version tag exists, the cmdlet reads commits from `tag..HEAD`.
If no tag exists, it reads the full commit history visible from `HEAD`.

## EXAMPLES

### Example 1

Collect commit messages since the most recent version tag.

```powershell
PS> Get-SemanticReleaseCommitMessage

feat: add preview release support
fix: preserve prerelease finalization behavior
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

### System.String[]

Returns trimmed commit-message entries with blank delimiter blocks removed.

## NOTES

- The cmdlet preserves the release-parser delimiter and split behavior used by the underlying private helpers.
- A non-repository path returns an empty collection.

## RELATED LINKS

- [Get-SemanticReleaseCommitRange](./Get-SemanticReleaseCommitRange.md)
- [Get-SemanticReleaseLabel](./Get-SemanticReleaseLabel.md)
