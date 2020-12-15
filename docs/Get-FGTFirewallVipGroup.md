---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTFirewallVipGroup

## SYNOPSIS
Get VIP group(s) configured

## SYNTAX

### default (Default)
```
Get-FGTFirewallVipGroup [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### name
```
Get-FGTFirewallVipGroup [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### uuid
```
Get-FGTFirewallVipGroup [-uuid <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### filter
```
Get-FGTFirewallVipGroup [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Show VIP group(s) configured (Name, Member...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTFirewallVipGroup
```

Display all VIP groups.

### EXAMPLE 2
```
Get-FGTFirewallVipGroup -name myFGTVipGroup
```

Get VIP Group named myFGTVipGroup

### EXAMPLE 3
```
Get-FGTFirewallVipGroup -name FGT -filter_type contains
```

Get VIP Group(s) containing *FGT*

### EXAMPLE 4
```
Get-FGTFirewallVipGroup -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702
```

Get VIP Group with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

### EXAMPLE 5
```
Get-FGTFirewallVipGroup -skip
```

Display all VIP groups (but only relevant attributes)

### EXAMPLE 6
```
Get-FGTFirewallVipGroup -vdom vdomX
```

Display all VIP groups on vdomX

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

### -uuid
{{ Fill uuid Description }}

```yaml
Type: String
Parameter Sets: uuid
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
