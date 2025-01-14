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
Add-FGTFirewallAddress -name <String> [-fqdn <String>] [-interface <String>] [-comment <String>]
 [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ipmask
```
Add-FGTFirewallAddress -name <String> [-ip <IPAddress>] [-mask <IPAddress>] [-interface <String>]
 [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### iprange
```
Add-FGTFirewallAddress -name <String> [-startip <IPAddress>] [-endip <IPAddress>] [-interface <String>]
 [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### geography
```
Add-FGTFirewallAddress -name <String> [-country <String>] [-interface <String>] [-comment <String>]
 [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### mac
```
Add-FGTFirewallAddress -name <String> [-mac <String[]>] [-interface <String>] [-comment <String>]
 [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### dynamic
```
Add-FGTFirewallAddress -name <String> -sdn <String> -filter <String> [-interface <String>] [-comment <String>]
 [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### EXAMPLE 7
```
Add-FGTFirewallAddress -Name FGT-Country-FR -country FR
```

Add Address object type geo (country) with name FGT-Country-FR and value FR (France)

### EXAMPLE 8
```
Add-FGTFirewallAddress -Name FGT-Mac -mac 01:02:03:04:05:06
```

Add Address object type mac (macaddr) with name FGT-Mac and value 01:02:03:04:05:06

### EXAMPLE 9
```
Add-FGTFirewallAddress -Name FGT-Dynamic-SDN-MyVM -sdn MyVcenter -filter VMNAME=MyVM
```

Add Address object type dynamic (SDN) MyVcenter with name FGT-Dynamic-SDN-MyVM and filter VMNAME=MyVM

### EXAMPLE 10
```
$data = @{ "color" = 23 }
PS C:\>Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -data $data
```

Add Address object type ipmask with name FGT and value 192.0.2.0/24 and color (23) via -data parameter

## PARAMETERS

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

### -country
{{ Fill country Description }}

```yaml
Type: String
Parameter Sets: geography
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mac
{{ Fill mac Description }}

```yaml
Type: String[]
Parameter Sets: mac
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sdn
{{ Fill sdn Description }}

```yaml
Type: String
Parameter Sets: dynamic
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter
{{ Fill filter Description }}

```yaml
Type: String
Parameter Sets: dynamic
Aliases:

Required: True
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

### -allowrouting
{{ Fill allowrouting Description }}

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

### -data
{{ Fill data Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
