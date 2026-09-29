---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 09.29.2026
PlatyPS schema version: 2024-05-01
title: Get-SemanticReleaseLabel
---

# Get-SemanticReleaseLabel

## SYNOPSIS

Infers a semantic-release label from commit messages.

## SYNTAX

### __AllParameterSets

```
Get-SemanticReleaseLabel [-Message] <string[]>
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to map Conventional Commit messages to a semantic-release label.

Breaking changes resolve to `Major`, `feat` commits resolve to `Minor`, and `fix` commits resolve to `Patch`.
Unmatched commit sets also default to `Patch`.

## EXAMPLES

### Example 1

Infer a label from a collected commit set.

```powershell
PS> Get-SemanticReleaseLabel -Message @(
>>     'feat: add release plan command'
>>     'fix: preserve preview numbering'
>> )

Minor
```

## PARAMETERS

### -Message

Specifies the commit messages to evaluate.

```yaml
Type: System.String[]
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

Returns `Major`, `Minor`, or `Patch`.

## NOTES

- The cmdlet recognizes both `BREAKING CHANGE` footers and Conventional Commit `!` markers as major-version triggers.
- Messages are matched case-insensitively.

## RELATED LINKS

- [Get-SemanticReleaseCommitMessage](./Get-SemanticReleaseCommitMessage.md)
- [Get-SemanticReleaseNextVersion](./Get-SemanticReleaseNextVersion.md)
