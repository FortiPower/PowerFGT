---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTUserSAML

## SYNOPSIS
Get list of all "SAML users"

## SYNTAX

### default (Default)
```
Get-FGTUserSAML [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### name
```
Get-FGTUserSAML [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### id
```
Get-FGTUserSAML [-id <String>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTUserSAML [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all "SAML users" (name, type, status...
)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTUserSAML
```

Display all SAML users

### EXAMPLE 2
```
Get-FGTUserSAML -id 23
```

Get SAML user with id 23

### EXAMPLE 3
```
Get-FGTUserSAML -name FGT -filter_type contains
```

Get SAML user contains with *FGT*

### EXAMPLE 4
```
Get-FGTUserSAML -skip
```

Display all SAML users (but only relevant attributes)

### EXAMPLE 5
```
Get-FGTUserSAML -vdom vdomX
```

Display all SAML users on vdomX

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
{{ Fill id Description }}

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_attribute
{{ Fill filter_attribute Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_type
{{ Fill filter_type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Equal
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_value
{{ Fill filter_value Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -skip
Ignores the specified number of objects and then gets the remaining objects.
Enter the number of objects to skip.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -vdom
{{ Fill vdom Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -connection
{{ Fill connection Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $DefaultFGTConnection
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
