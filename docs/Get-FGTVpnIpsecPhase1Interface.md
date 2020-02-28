---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTVpnIpsecPhase1Interface

## SYNOPSIS
Get list of all VPN IPsec phase 1 (ISAKMP) settings

## SYNTAX

### default (Default)
```
Get-FGTVpnIpsecPhase1Interface [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### name
```
Get-FGTVpnIpsecPhase1Interface [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### filter
```
Get-FGTVpnIpsecPhase1Interface [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all VPN IPsec phase 1 (name, IP Address, description, pre shared key ...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTVpnIPsecPhase1Interface
```

Get list of all settings of VPN IPsec Phase 1 interface

### EXAMPLE 2
```
Get-FGTVpnIPsecPhase1Interface -name myVPNIPsecPhase1interface
```

Get VPN IPsec Phase 1 interface named myVPNIPsecPhase1interface

### EXAMPLE 3
```
Get-FGTVpnIPsecPhase1Interface -name FGT -filter_type contains
```

Get VPN IPsec Phase 1 interface contains with *FGT*

### EXAMPLE 4
```
Get-FGTVpnIPsecPhase1Interface -skip
```

Get list of all settings of VPN IPsec Phase 1 interface (but only relevant attributes)

### EXAMPLE 5
```
Get-FGTVpnIPsecPhase1Interface -vdom vdomX
```

Get list of all settings of VPN IPsec Phase 1 interface on vdomX

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
