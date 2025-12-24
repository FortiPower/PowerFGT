---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTFirewallProxyAddressGroup

## SYNOPSIS
Get proxy-addresses group configured

## SYNTAX

### default (Default)
```
Get-FGTFirewallProxyAddressGroup [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### name
```
Get-FGTFirewallProxyAddressGroup [[-name] <String>] [-filter_type <String>] [-meta] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### uuid
```
Get-FGTFirewallProxyAddressGroup [-uuid <String>] [-filter_type <String>] [-meta] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter_build
```
Get-FGTFirewallProxyAddressGroup [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### schema
```
Get-FGTFirewallProxyAddressGroup [-meta] [-skip] [-schema] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Show proxy-addresses group configured (Name, Member...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTFirewallProxyAddressGroup
```

Display all addresses group.

### EXAMPLE 2
```
Get-FGTFirewallProxyAddressGroup -name myFGTProxyAddressGroup
```

Get  Address Group named myFGTProxyAddressGroup

### EXAMPLE 3
```
Get-FGTFirewallProxyAddressGroup -name FGT -filter_type contains
```

Get  Address Group contains *FGT*

### EXAMPLE 4
```
Get-FGTFirewallProxyAddressGroup -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702
```

Get Address Group with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

### EXAMPLE 5
```
Get-FGTFirewallProxyAddressGroup -meta
```

Display all proxy-address group  with metadata (q_...) like usage (q_ref)

### EXAMPLE 6
```
Get-FGTFirewallProxyAddressGroup -skip
```

Display all addresses group (but only relevant attributes)

### EXAMPLE 7
```
Get-FGTFirewallProxyAddressGroup -schema
```

Get schema of Proxy Address Group

### EXAMPLE 8
```
Get-FGTFirewallProxyAddressGroup -vdom vdomX
```

Display all addresses group on vdomX

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
Parameter Sets: filter_build
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
Parameter Sets: name, uuid, filter_build
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
Parameter Sets: filter_build
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -meta
{{ Fill meta Description }}

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

### -schema
{{ Fill schema Description }}

```yaml
Type: SwitchParameter
Parameter Sets: schema
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
