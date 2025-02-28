---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallServiceCustom

## SYNOPSIS
Add a FortiGate service object

## SYNTAX

### tcp/udp/sctp
```
Add-FGTFirewallServiceCustom [-name] <String> [-tcp_port <String[]>] [-udp_port <String[]>]
 [-sctp_port <String[]>] [-comment <String>] [-category <String>] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ip
```
Add-FGTFirewallServiceCustom [-name] <String> -protocolNumber <Int32> [-comment <String>] [-category <String>]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### icmp
```
Add-FGTFirewallServiceCustom [-name] <String> -icmpType <Int32> -icmpCode <Int32> [-comment <String>]
 [-category <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a Fortigate service object (TCP/UDP/SCTP, IP, ICMP)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8080 -tcp_port 8080 -comment "Service Custom using TCP 8080"
```

Add service object MyServiceCustomTCP8080 using TCP Port 8080 and a comment

### EXAMPLE 2
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomUDP5353 -udp_port 5353 -comment "Service Custom using UDP 5353"
```

Add service object MyServiceCustomUDP5353 using UDP Port 5353 and a comment

### EXAMPLE 3
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomTCPRange8000_9000 -tcp_port "8000-9000"
```

Add service object MyServiceCustomTCPRange8000_9000 using TCP Port Range 8000-9000

### EXAMPLE 4
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8000_TCP8090 -tcp_port 8080,8090
```

Add service object MyServiceCustomTCP8000_TCP8090 using TCP Port 8080 and 8090

### EXAMPLE 5
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP_UDP_8080 -tcp_port 8080 -udp_port 8080
```

Add service object MyServiceCustomTCP_UDP_8080 using TCP Port 8080 and UDP Port 8080

### EXAMPLE 6
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomICMP -icmpType 8 -icmpCode 0 -comment "service object for ping"
```

Add service object MyServiceCustomICMP with protocol type ICMP and ICMP type 8 (echo request), ICMP code 0

### EXAMPLE 7
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP -protocolNumber 6 -comment "default protocol number for tcp"
```

Add service object MyServiceCustomTCP with protocol type ip, protocol number 6 (tcp) and a comment

### EXAMPLE 8
```
Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8081 -tcp_port 8081 -category "Web Access"
```

Add service object MyServiceCustomTCP8080 using TCP Port 8081 and the category "Web Access"

### EXAMPLE 9
```
$data = @{ "color" = 23 }
PS C:\>Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8082 -tcp_port 8082 -data $data
```

Add service object MyServiceCustomTCP8080 using TCP Port 8082 and color (23) via $data

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
