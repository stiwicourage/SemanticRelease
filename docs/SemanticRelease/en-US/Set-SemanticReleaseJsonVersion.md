---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 09.29.2026
PlatyPS schema version: 2024-05-01
title: Set-SemanticReleaseJsonVersion
---

# Set-SemanticReleaseJsonVersion

## SYNOPSIS

Updates a semantic version key in a JSON file using semantic-release version rules.

## SYNTAX

### __AllParameterSets

```
Set-SemanticReleaseJsonVersion [-Path] <string> [[-Key] <string>] [[-Label] <string>]
 [[-ReleaseType] <string>] [-WhatIf] [-Confirm]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to read a top-level version value from a JSON file, calculate the next semantic version, and write the updated value back to the file.

The cmdlet reads JSON with `ConvertFrom-Json -AsHashtable`, writes JSON with `ConvertTo-Json -Depth 20`, and supports `ShouldProcess` for safe preview runs.

## EXAMPLES

### Example 1

Preview a patch update for the default `Version` key.

```powershell
PS> Set-SemanticReleaseJsonVersion -Path ./project.json -ReleaseType Preview -WhatIf
What if: Performing the operation "Set Version to 0.1.1" on target "project.json".
```

### Example 2

Update a custom version key in a JSON file.

```powershell
PS> Set-SemanticReleaseJsonVersion -Path ./package.json -Key Version -Label Minor -Confirm:$false

Path            : ./package.json
Target          : package.json
Key             : Version
PreviousVersion : 1.2.3
NewVersion      : 1.3.0
Applied         : True
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

Specifies the top-level JSON key that contains the semantic version. The default value is `Version`.

```yaml
Type: System.String
DefaultValue: Version
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

### -Label

Specifies which semantic version part to target. Valid values are `Major`, `Minor`, and `Patch`.

```yaml
Type: System.String
DefaultValue: Patch
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

Specifies the JSON file to update.

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

### -ReleaseType

Specifies how the cmdlet should emit the next version. Valid values are `Default`, `Preview`, and `Stable`.

```yaml
Type: System.String
DefaultValue: Default
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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

### System.Management.Automation.PSCustomObject

Returns a result object with `Path`, `Target`, `Key`, `PreviousVersion`, `NewVersion`, and `Applied` properties.

## NOTES

- The cmdlet updates only top-level JSON keys.
- If the specified key is missing, the cmdlet throws.

## RELATED LINKS

- [Get-SemanticReleaseNextVersion](./Get-SemanticReleaseNextVersion.md)
- [Get-SemanticReleaseLabel](./Get-SemanticReleaseLabel.md)
