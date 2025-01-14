---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallAddress

## SYNOPSIS
Configure a FortiGate Address

## SYNTAX

### default (Default)
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-interface <String>] [-comment <String>]
 [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### fqdn
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-fqdn <String>] [-interface <String>]
 [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ipmask
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-ip <IPAddress>] [-mask <IPAddress>]
 [-interface <String>] [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### iprange
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-startip <IPAddress>] [-endip <IPAddress>]
 [-interface <String>] [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### geography
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-country <String>] [-interface <String>]
 [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### mac
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-mac <String[]>] [-interface <String>]
 [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### dynamic
```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-sdn <String>] [-filter <String>]
 [-interface <String>] [-comment <String>] [-visibility <Boolean>] [-allowrouting] [-data <Hashtable>]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Address (ip, mask, comment, associated interface...
)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.0.2.0 -mask 255.255.255.0
```

Change MyFGTAddress to value (ip and mask) 192.0.2.0/24

### EXAMPLE 2
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.0.2.1
```

Change MyFGTAddress to value (ip) 192.0.2.1

### EXAMPLE 3
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -interface port1
```

Change MyFGTAddress to set associated interface to port 1

### EXAMPLE 4
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -comment "My FGT Address" -visibility:$false
```

Change MyFGTAddress to set a new comment and disabled visibility

### EXAMPLE 5
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -fqdn fortipower.github.io
```

Change MyFGTAddress to set a new fqdn fortipower.github.io

### EXAMPLE 6
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -startip 192.0.2.100
```

Change MyFGTAddress to set a new startip (iprange) 192.0.2.100

### EXAMPLE 7
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -endip 192.0.2.200
```

Change MyFGTAddress to set a new endip (iprange) 192.0.2.200

### EXAMPLE 8
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -country FR
```

Change MyFGTAddress to set a new country (geo) FR (France)

### EXAMPLE 9
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -mac 01:02:03:04:05:06
```

Change MyFGTAddress to set a new mac address 01:02:03:04:05:06

### EXAMPLE 10
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -filter VMNAME=MyVM
```

Change MyFGTAddress to set a new filter VMNANME=MyVM

### EXAMPLE 11
```
$data = @{ "color" = 23 }
PS C:\>$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -data $color
```

Change MyFGTAddress to set a color (23) using -data

## PARAMETERS

### -address
{{ Fill address Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -name
{{ Fill name Description }}

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

Required: False
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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
