---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTMonitorRouterIPv4

## SYNOPSIS
Get Router IPv4

## SYNTAX

```
Get-FGTMonitorRouterIPv4 [[-ip_mask] <String>] [[-gateway] <String>] [[-type] <String>] [[-interface] <String>]
 [-skip] [[-vdom] <String[]>] [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
List all active IPv4 routing table entries (type, IP/Mask, gateway, interface...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTMonitorRouterIPv4
```

Get ALL Router IPv4 Monitor

### EXAMPLE 2
```
Get-FGTMonitorRouterIPv4 -ip_mask 192.0.2.0/24
```

Get Router IPv4 Monitor where IP/MASK is 192.0.2.0/24

### EXAMPLE 3
```
Get-FGTMonitorRouterIPv4 -gateway 192.0.2.1
```

Get Router IPv4 Monitor where Gateway is 192.0.2.1

### EXAMPLE 4
```
Get-FGTMonitorRouterIPv4 -type connected
```

Get Router IPv4 Monitor with type is connected

### EXAMPLE 5
```
Get-FGTMonitorRouterIPv4 -interface port1
```

Get Router IPv4 Monitor where interface is port1

### EXAMPLE 6
```
Get-FGTMonitorRouterIPv4 -vdom vdomX
```

Get Router IPv4 monitor of vdomX

## PARAMETERS

### -ip_mask
{{ Fill ip_mask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -gateway
{{ Fill gateway Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
{{ Fill type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -interface
{{ Fill interface Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
