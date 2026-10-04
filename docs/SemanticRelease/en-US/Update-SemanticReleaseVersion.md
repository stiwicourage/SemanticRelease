---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 10.04.2026
PlatyPS schema version: 2024-05-01
title: Update-SemanticReleaseVersion
---

# Update-SemanticReleaseVersion

## SYNOPSIS

Infers the next semantic version from Git commit history and updates a JSON or `.properties` version file.

## SYNTAX

### __AllParameterSets

```
Update-SemanticReleaseVersion [-Path] <string> [[-ProjectRoot] <string>] [[-Key] <string>]
 [-Preview] [-WhatIf] [-Confirm]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to read commit messages from the current Git repository, infer the semantic-release label, calculate the next version, and write that version into a supported version file.

`Update-SemanticReleaseVersion` supports top-level JSON version keys such as `project.json` and Java-style `.properties` version keys such as `gradle.properties`. Use `-Preview` to continue or seed preview versions without changing the stable release branch semantics.

## EXAMPLES

### Example 1

Update a preview version in `gradle.properties` based on the commits since the last version tag.

```powershell
PS> Update-SemanticReleaseVersion -Path ./gradle.properties -ProjectRoot . -Preview -Confirm:$false

Path            : ./gradle.properties
Target          : gradle.properties
Key             : version
PreviousVersion : 0.11.1-preview01
NewVersion      : 0.11.1-preview02
Applied         : True
Label           : Minor
PreviewRelease  : True
CommitMessages  : {feat: add preview publish automation}
CommitCount     : 1
```

### Example 2

Apply the next stable version to `project.json`.

```powershell
PS> Update-SemanticReleaseVersion -Path ./project.json -ProjectRoot . -Confirm:$false

Path            : ./project.json
Target          : project.json
Key             : Version
PreviousVersion : 1.2.3
NewVersion      : 1.2.4
Applied         : True
Label           : Patch
PreviewRelease  : False
CommitMessages  : {fix: correct release workflow}
CommitCount     : 1
```

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -Key

Specifies the version key to update. The default is `Version` for JSON files and `version` for `.properties` files.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

Specifies the JSON or `.properties` file that stores the version to update.

```yaml
Type: System.String
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

### -Preview

Specifies that the update should use preview-release semantics.

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

### -ProjectRoot

Specifies the Git repository root to inspect for commit messages. The default is the current location.

```yaml
Type: System.String
DefaultValue: ''
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### System.Object

Returns an object that reports the target file, the previous version, the new version, whether the change was applied, the inferred release label, and the commit messages used for inference.

## NOTES

The cmdlet reads commit messages through Git, using the same commit-range detection rules as `Get-SemanticReleaseCommitMessage`.

## RELATED LINKS

- [Get-SemanticReleaseCommitMessage](./Get-SemanticReleaseCommitMessage.md)
- [Get-SemanticReleaseLabel](./Get-SemanticReleaseLabel.md)
- [Get-SemanticReleaseNextVersion](./Get-SemanticReleaseNextVersion.md)
- [Set-SemanticReleaseJsonVersion](./Set-SemanticReleaseJsonVersion.md)
- [Set-SemanticReleasePropertiesVersion](./Set-SemanticReleasePropertiesVersion.md)
