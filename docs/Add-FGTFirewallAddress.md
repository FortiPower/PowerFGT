---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallAddress

## SYNOPSIS
Add a FortiGate Address

## SYNTAX

### fqdn
```
Add-FGTFirewallAddress [-type <String>] -name <String> [-fqdn <String>] [-interface <String>]
 [-comment <String>] [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### ipmask
```
Add-FGTFirewallAddress [-type <String>] -name <String> [-ip <IPAddress>] [-mask <IPAddress>]
 [-interface <String>] [-comment <String>] [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

### iprange
```
Add-FGTFirewallAddress [-type <String>] -name <String> [-startip <IPAddress>] [-endip <IPAddress>]
 [-interface <String>] [-comment <String>] [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Address (ipmask, iprange, fqdn)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0
```

Add Address object type ipmask with name FGT and value 192.0.2.0/24

### EXAMPLE 2
```
Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -interface port2
```

Add Address object type ipmask with name FGT, value 192.0.2.0/24 and associated to interface port2

### EXAMPLE 3
```
Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -comment "My FGT Address"
```

Add Address object type ipmask with name FGT, value 192.0.2.0/24 and a comment

### EXAMPLE 4
```
Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -visibility:$false
```

Add Address object type ipmask with name FGT, value 192.0.2.0/24 and disabled visibility

### EXAMPLE 5
```
Add-FGTFirewallAddress -Name FortiPower -fqdn fortipower.github.io
```

Add Address object type fqdn with name FortiPower and value fortipower.github.io

### EXAMPLE 6
```
Add-FGTFirewallAddress -Name FGT-Range -startip 192.0.2.1 -endip 192.0.2.100
```

Add Address object type iprange with name FGT-Range with start IP 192.0.2.1 and end ip 192.0.2.100

## PARAMETERS

### -type
{{ Fill type Description }}

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

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fqdn
{{ Fill fqdn Description }}

```yaml
Type: String
Parameter Sets: fqdn
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ip
{{ Fill ip Description }}

```yaml
Type: IPAddress
Parameter Sets: ipmask
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mask
{{ Fill mask Description }}

```yaml
Type: IPAddress
Parameter Sets: ipmask
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -startip
{{ Fill startip Description }}

```yaml
Type: IPAddress
Parameter Sets: iprange
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -endip
{{ Fill endip Description }}

```yaml
Type: IPAddress
Parameter Sets: iprange
Aliases:

Required: False
Position: Named
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

### -visibility
{{ Fill visibility Description }}

```yaml
Type: Boolean
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
