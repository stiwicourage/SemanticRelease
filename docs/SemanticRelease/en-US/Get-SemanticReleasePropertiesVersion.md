---
document type: cmdlet
external help file: SemanticRelease-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SemanticRelease
ms.date: 11.08.2026
PlatyPS schema version: 2024-05-01
title: Get-SemanticReleasePropertiesVersion
---

# Get-SemanticReleasePropertiesVersion

## SYNOPSIS

Reads the current version from a Java-style `.properties` file without changing the file.

## SYNTAX

### __AllParameterSets

```
Get-SemanticReleasePropertiesVersion [-Path] <string> [[-Key] <string>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Use this cmdlet to read the version-like property from a Java-style `.properties` file such as `gradle.properties`, for example to log the current version or to validate whether it is a preview or stable version before calling `Set-SemanticReleasePropertiesVersion`.

The cmdlet uses the same parsing rules as `Set-SemanticReleasePropertiesVersion`: it supports the `key=value` and `key:value` syntaxes and ignores comment lines.

## EXAMPLES

### Example 1

Read the `version` property from `gradle.properties`.

```powershell
PS> Get-SemanticReleasePropertiesVersion -Path ./gradle.properties

Path    : ./gradle.properties
Key     : version
Version : 1.2.3-preview01
```

### Example 2

Read a custom property key.

```powershell
PS> (Get-SemanticReleasePropertiesVersion -Path ./gradle.properties -Key pluginVersion).Version
1.2.3
```

## PARAMETERS

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

### -Path

Specifies the Java-style `.properties` file to read.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject

Returns an object with `Path`, `Key`, and `Version` properties.

## NOTES

- The cmdlet reads the first matching non-comment property line.
- If the specified key is missing or the file is empty, the cmdlet throws.

## RELATED LINKS

- [Set-SemanticReleasePropertiesVersion](./Set-SemanticReleasePropertiesVersion.md)
