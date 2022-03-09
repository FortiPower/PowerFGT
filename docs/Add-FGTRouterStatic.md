---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTRouterStatic

## SYNOPSIS
Add a FortiGate static route

## SYNTAX

### default (Default)
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] [-gateway <String>] [-distance <Int32>] [-weight <Int32>]
 [-priority <Int32>] [-comment <String>] [-dynamic_gateway] [-internet_service_custom <String>]
 [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

### dst_blackhole
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] -dst <String> [-gateway <String>] [-distance <Int32>]
 [-weight <Int32>] [-priority <Int32>] [-comment <String>] [-blackhole] [-dynamic_gateway]
 [-internet_service_custom <String>] [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

### dst_device
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] -dst <String> [-gateway <String>] [-distance <Int32>]
 [-weight <Int32>] [-priority <Int32>] -device <String> [-comment <String>] [-dynamic_gateway]
 [-internet_service_custom <String>] [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

### isdb_device
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] [-gateway <String>] [-distance <Int32>] [-weight <Int32>]
 [-priority <Int32>] -device <String> [-comment <String>] [-dynamic_gateway] -internet_service <Int32>
 [-internet_service_custom <String>] [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

### dstaddr_device
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] [-gateway <String>] [-distance <Int32>] [-weight <Int32>]
 [-priority <Int32>] -device <String> [-comment <String>] [-blackhole] [-dynamic_gateway] -dstaddr <String>
 [-internet_service_custom <String>] [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

### isdb_blackhole
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] [-gateway <String>] [-distance <Int32>] [-weight <Int32>]
 [-priority <Int32>] [-comment <String>] [-blackhole] [-dynamic_gateway] -internet_service <Int32>
 [-internet_service_custom <String>] [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

### dstaddr_blackhole
```
Add-FGTRouterStatic [-seq_num <Int32>] [-status] [-gateway <String>] [-distance <Int32>] [-weight <Int32>]
 [-priority <Int32>] [-comment <String>] [-dynamic_gateway] -dstaddr <String>
 [-internet_service_custom <String>] [-link_monitor_exempt] [-vrf <Int32>] [-bfd] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate static route

## EXAMPLES

### EXAMPLE 1
```
Add-FGTRouterStatic -status -dst 198.51.100.0/24 -gateway 192.0.2.254 -device internal1 -comment "Example_PowerFGT" -distance 10
```

Add a route to 198.51.100.0/24 with gateway 192.2.0.254 by the interface named internal1, with Example_PowerFGT as the description, with an administrative distance of 10

### EXAMPLE 2
```
Add-FGTRouterStatic -status:$false -dst 198.51.100.0/24 -gateway 192.0.2.254 -device internal1
```

Add a route with status disabled

## PARAMETERS

### -seq_num
{{ Fill seq_num Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -status
{{ Fill status Description }}

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

### -dst
{{ Fill dst Description }}

```yaml
Type: String
Parameter Sets: dst_blackhole, dst_device
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -gateway
historic settings ?
        \[string\]$src,
        \[Parameter (Mandatory = $false)\]

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

### -distance
{{ Fill distance Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -weight
{{ Fill weight Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -priority
{{ Fill priority Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -device
{{ Fill device Description }}

```yaml
Type: String
Parameter Sets: dst_device, isdb_device, dstaddr_device
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -comment
{{ Fill comment Description }}

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

### -blackhole
{{ Fill blackhole Description }}

```yaml
Type: SwitchParameter
Parameter Sets: dst_blackhole, dstaddr_device, isdb_blackhole
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -dynamic_gateway
{{ Fill dynamic_gateway Description }}

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

### -dstaddr
{{ Fill dstaddr Description }}

```yaml
Type: String
Parameter Sets: dstaddr_device, dstaddr_blackhole
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -internet_service
{{ Fill internet_service Description }}

```yaml
Type: Int32
Parameter Sets: isdb_device, isdb_blackhole
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -internet_service_custom
{{ Fill internet_service_custom Description }}

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

### -link_monitor_exempt
{{ Fill link_monitor_exempt Description }}

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

### -vrf
{{ Fill vrf Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -bfd
{{ Fill bfd Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
