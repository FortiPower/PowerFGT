---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallServiceCustom

## SYNOPSIS
Configure a FortiGate Service Custom

## SYNTAX

### default (Default)
```
Set-FGTFirewallServiceCustom [-servicecustom] <PSObject> [-name <String>] [-comment <String>]
 [-category <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### tcp/udp/sctp
```
Set-FGTFirewallServiceCustom [-servicecustom] <PSObject> [-name <String>] [-tcp_port <String[]>]
 [-udp_port <String[]>] [-sctp_port <String[]>] [-comment <String>] [-category <String>] [-data <Hashtable>]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ip
```
Set-FGTFirewallServiceCustom [-servicecustom] <PSObject> [-name <String>] -protocolNumber <Int32>
 [-comment <String>] [-category <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### icmp
```
Set-FGTFirewallServiceCustom [-servicecustom] <PSObject> [-name <String>] -icmpType <Int32> -icmpCode <Int32>
 [-comment <String>] [-category <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Service Custom (Name, TCP / UDP / SCTP Port, coments...
)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -tcp_port 8080
```

Change MyFGTServiceCustom tcp-port to 8080

### EXAMPLE 2
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -tcp_port 8080-8090
```

Change MyFGTServiceCustom tcp-port (range) to 8080-8090

### EXAMPLE 3
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -tcp_port 8080, 9090
```

Change MyFGTServiceCustom tcp-port to 8080 and 9090

### EXAMPLE 4
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -udp_port 5353
```

Change MyFGTServiceCustom udp-port to 5353

### EXAMPLE 5
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -name MyFGTServiceCustom2
```

Change MyFGTServiceCustom name to MyFGTServiceCustom2

### EXAMPLE 6
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -comment "My New comment"
```

Change MyFGTServiceCustom comment "My New Comment"

### EXAMPLE 7
```
$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -category "Email"
```

Change MyFGTServiceCustom category "Email"

### EXAMPLE 8
```
$data = @{ "color" = 23 }
PS C:\>$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -data $color
```

Change MyFGTServiceCustom to set a color (23) using -data

## PARAMETERS

### -servicecustom
{{ Fill servicecustom Description }}

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

### -tcp_port
{{ Fill tcp_port Description }}

```yaml
Type: String[]
Parameter Sets: tcp/udp/sctp
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -udp_port
{{ Fill udp_port Description }}

```yaml
Type: String[]
Parameter Sets: tcp/udp/sctp
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sctp_port
{{ Fill sctp_port Description }}

```yaml
Type: String[]
Parameter Sets: tcp/udp/sctp
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -protocolNumber
{{ Fill protocolNumber Description }}

```yaml
Type: Int32
Parameter Sets: ip
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -icmpType
{{ Fill icmpType Description }}

```yaml
Type: Int32
Parameter Sets: icmp
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -icmpCode
{{ Fill icmpCode Description }}

```yaml
Type: Int32
Parameter Sets: icmp
Aliases:

Required: True
Position: Named
Default value: 0
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

### -category
{{ Fill category Description }}

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
