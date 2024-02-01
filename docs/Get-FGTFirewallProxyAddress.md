---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTFirewallProxyAddress

## SYNOPSIS
Get list of all "proxy-address"

## SYNTAX

### default (Default)
```
Get-FGTFirewallProxyAddress [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### name
```
Get-FGTFirewallProxyAddress [[-name] <String>] [-filter_type <String>] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### uuid
```
Get-FGTFirewallProxyAddress [-uuid <String>] [-filter_type <String>] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter_build
```
Get-FGTFirewallProxyAddress [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all "proxy-address" (host-regex, url ...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTFirewallProxyAddress
```

Get list of all proxy-address object

### EXAMPLE 2
```
Get-FGTFirewallProxyAddress -name myFGTPoxyAddress
```

Get proxy-address named myFGTProxyAddress

### EXAMPLE 3
```
Get-FGTFirewallProxyAddress -name FGT -filter_type contains
```

Get proxy-address contains with *FGT*

### EXAMPLE 4
```
Get-FGTFirewallProxyAddress -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702
```

Get proxy-address with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

### EXAMPLE 5
```
Get-FGTFirewallProxyAddress -skip
```

Get list of all proxy-address object (but only relevant attributes)

### EXAMPLE 6
```
Get-FGTFirewallProxyAddress -vdom vdomX
```

Get list of all proxy-address on VdomX

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
