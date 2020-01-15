---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTFirewallServiceGroup

## SYNOPSIS
Get list of all "services group"

## SYNTAX

### default (Default)
```
Get-FGTFirewallServiceGroup [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### name
```
Get-FGTFirewallServiceGroup [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### filter
```
Get-FGTFirewallServiceGroup [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all "services group"

## EXAMPLES

### EXAMPLE 1
```
Get-FGTFirewallServiceGroup
```

Get list of all services group object

### EXAMPLE 2
```
Get-FGTFirewallServiceGroup -name myFirewallServiceGroup
```

Get services group object named myFirewallServiceCustom

### EXAMPLE 3
```
Get-FGTFirewallServiceGroup -name FGT -filter_type contains
```

Get services group object contains with *FGT*

### EXAMPLE 4
```
Get-FGTFirewallServiceGroup -skip
```

Get list of all services group object (but only relevant attributes)

### EXAMPLE 5
```
Get-FGTFirewallServiceGroup -vdom vdomX
```

Get list of all services group object on vdomX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
