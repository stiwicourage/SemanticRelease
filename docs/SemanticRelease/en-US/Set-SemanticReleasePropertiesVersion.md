---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 09.30.2026
PlatyPS schema version: 2024-05-01
title: Set-SemanticReleasePropertiesVersion
---

# Set-SemanticReleasePropertiesVersion

## SYNOPSIS

Updates a semantic version property in a Java-style `.properties` file using semantic-release version rules.

## SYNTAX

### __AllParameterSets

```
Set-SemanticReleasePropertiesVersion [-Path] <string> [[-Key] <string>] [[-Label] <string>]
 [[-ReleaseType] <string>] [-WhatIf] [-Confirm]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to read a version-like property from a Java-style `.properties` file, calculate the next semantic version, and write the updated value back to the file.

The cmdlet supports the common `key=value` and `key:value` property syntaxes, preserves surrounding whitespace on the updated line, and supports `ShouldProcess` for safe preview runs.

## EXAMPLES

### Example 1

Preview the next preview version for the `version` property in `gradle.properties`.

```powershell
PS> Set-SemanticReleasePropertiesVersion -Path ./gradle.properties -ReleaseType Preview -WhatIf
What if: Performing the operation "Set version to 0.1.1-preview01" on target "gradle.properties".
```

### Example 2

Update a custom property key in a Java-style properties file.

```powershell
PS> Set-SemanticReleasePropertiesVersion -Path ./gradle.properties -Key pluginVersion -Label Minor -Confirm:$false

Path            : ./gradle.properties
Target          : gradle.properties
Key             : pluginVersion
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

Specifies the property key that contains the semantic version. The default value is `version`.

```yaml
Type: System.String
DefaultValue: version
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

Specifies the Java-style `.properties` file to update.

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

- The cmdlet updates the first matching non-comment property line.
- Supported property separators are `=` and `:`.
- If the specified key is missing, the cmdlet throws.

## RELATED LINKS

- [Get-SemanticReleaseNextVersion](./Get-SemanticReleaseNextVersion.md)
- [Set-SemanticReleaseJsonVersion](./Set-SemanticReleaseJsonVersion.md)
