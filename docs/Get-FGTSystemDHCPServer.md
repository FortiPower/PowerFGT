---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTSystemDHCPServer

## SYNOPSIS
Get DHCP Server configured

## SYNTAX

### default (Default)
```
Get-FGTSystemDHCPServer [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### id
```
Get-FGTSystemDHCPServer [[-id] <Int32>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTSystemDHCPServer [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Show DHCP Server configured on the FortiGate

## EXAMPLES

### EXAMPLE 1
```
Get-FGTSystemDHCPServer
```

Display DHCP Server configured on the FortiGate

### EXAMPLE 2
```
Get-FGTSystemDHCPServer -id 2
```

Get System DHCP Server with id 2

### EXAMPLE 3
```
Get-FGTSystemDHCPServer -filter_attribute 'default-gateway' -filter_value 92.2.0.254
```

Get System DHCP Server with default-gateway equal 192.2.0.254

### EXAMPLE 4
```
Get-FGTSystemDHCPServer -filter_attribute domain -filter_value PowerFGT -filter_type contains
```

Get System Server DHCP with domain contains PowerFGT

### EXAMPLE 5
```
Get-FGTSystemDHCPServer -meta
```

Display DHCP Server configured on the FortiGate with metadata (q_...) like usage (q_ref)

### EXAMPLE 6
```
Get-FGTSystemDHCPServer -skip
```

Display DHCP Server configured on the FortiGate (but only relevant attributes)

EXAMPLE
Get-FGTSystemDHCPServer -vdom vdomX

Display DHCP Server configured on the FortiGate on vdomX

## PARAMETERS

### -id
{{ Fill id Description }}

```yaml
Type: Int32
Parameter Sets: id
Aliases:

Required: False
Position: 2
Default value: 0
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
