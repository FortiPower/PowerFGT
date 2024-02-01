---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallProxyPolicy

## SYNOPSIS
Add a FortiGate Proxy Policy

## SYNTAX

```
Add-FGTFirewallProxyPolicy [-proxy] <String> [[-policyid] <Int32>] [[-srcintf] <String[]>]
 [-dstintf] <String[]> [-srcaddr] <String[]> [-dstaddr] <String[]> [[-action] <String>] [-status]
 [[-schedule] <String>] [[-service] <String[]>] [[-comments] <String>] [[-logtraffic] <String>] [-skip]
 [[-vdom] <String[]>] [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Proxy Policy/Rules (source address, destination address, service, action, status...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all
```

Add an explicit-web Proxy Policy with destination interface port1, source-address and destination-address all

### EXAMPLE 2
```
Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port2 -dstintf port1 -srcaddr all -dstaddr all
```

Add a transparent-web Proxy Policy with source interface port2, destination interface port1, source-address and destination-address all

### EXAMPLE 3
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all -action "deny"
```

Add an explicit-web Proxy Policy with action is Deny

### EXAMPLE 4
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all -status:$false
```

Add an explicit-web Proxy Policy with status is disable

### EXAMPLE 5
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all -service "HTTP, HTTPS, SSH"
```

Add an explicit-web Proxy Policy with multiple services

### EXAMPLE 6
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all -schedule workhour
```

Add an explicit-web Proxy Policy with schedule is workhour

### EXAMPLE 7
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all -comments "My FGT ProxyPolicy"
```

Add an explicit-web Proxy Policy with comment "My FGT ProxyPolicy"

### EXAMPLE 8
```
Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port1 -srcaddr all -dstaddr all -logtraffic "all"
```

Add an explicit-web Proxy Policy with log traffic all

## PARAMETERS

### -proxy
{{ Fill proxy Description }}

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

### -policyid
{{ Fill policyid Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -srcintf
{{ Fill srcintf Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dstintf
{{ Fill dstintf Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -srcaddr
{{ Fill srcaddr Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dstaddr
{{ Fill dstaddr Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -action
{{ Fill action Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Accept
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

### -schedule
{{ Fill schedule Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Always
Accept pipeline input: False
Accept wildcard characters: False
```

### -service
{{ Fill service Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Webproxy
Accept pipeline input: False
Accept wildcard characters: False
```

### -comments
{{ Fill comments Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -logtraffic
{{ Fill logtraffic Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
Position: 12
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
Position: 13
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
