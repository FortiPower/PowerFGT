---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallPolicy

## SYNOPSIS
Add a FortiGate Policy

## SYNTAX

```
Add-FGTFirewallPolicy [[-name] <String>] [[-policyid] <Int32>] [-srcintf] <String[]> [-dstintf] <String[]>
 [-srcaddr] <String[]> [-dstaddr] <String[]> [[-action] <String>] [-status] [[-schedule] <String>]
 [[-service] <String[]>] [-nat] [[-comments] <String>] [[-logtraffic] <String>] [[-ippool] <String[]>]
 [[-inspectionmode] <String>] [[-sslsshprofile] <String>] [[-avprofile] <String>]
 [[-webfilterprofile] <String>] [[-dnsfilterprofile] <String>] [[-ipssensor] <String>]
 [[-applicationlist] <String>] [-skip] [[-data] <Hashtable>] [[-vdom] <String[]>] [[-connection] <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Policy/Rules (source port/ip, destination port, ip, action, status...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
```

Add a MyFGTPolicy with source port port1 and destination port2 and source and destination all

### EXAMPLE 2
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat
```

Add a MyFGTPolicy with NAT is enable

### EXAMPLE 3
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "deny"
```

Add a MyFGTPolicy with action is Deny

### EXAMPLE 4
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -status:$false
```

Add a MyFGTPolicy with status is disable

### EXAMPLE 5
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service "HTTP, HTTPS, SSH"
```

Add a MyFGTPolicy with multiple service port

### EXAMPLE 6
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -schedule workhour
```

Add a MyFGTPolicy with schedule is workhour

### EXAMPLE 7
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -comments "My FGT Policy"
```

Add a MyFGTPolicy with comment "My FGT Policy"

### EXAMPLE 8
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic "all"
```

Add a MyFGTPolicy with log traffic all

### EXAMPLE 9
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat -ippool "MyIPPool"
```

Add a MyFGTPolicy with IP Pool MyIPPool (with nat)

### EXAMPLE 10
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -policyid 23
```

Add a MyFGTPolicy with Policy ID equal 23

### EXAMPLE 11
```
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -avprofile default -webfilterprofile default -dnsfilterprofile default -applicationlist default -ipssensor default
```

Add a MyFGTPolicy with Security Profile (Antivirus, WebFilter, DNS Filter, Application, IPS)

### EXAMPLE 12
```
$data = @{ "logtraffic-start" = "enable" }
Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -data $data
```

Add a MyFGTPolicy with logtraffic-start using -data

## PARAMETERS

### -name
{{ Fill name Description }}

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

Required: True
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
Default value: ALL
Accept pipeline input: False
Accept wildcard characters: False
```

### -nat
{{ Fill nat Description }}

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

### -ippool
{{ Fill ippool Description }}

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

### -inspectionmode
{{ Fill inspectionmode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sslsshprofile
{{ Fill sslsshprofile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -avprofile
{{ Fill avprofile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -webfilterprofile
{{ Fill webfilterprofile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dnsfilterprofile
{{ Fill dnsfilterprofile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ipssensor
{{ Fill ipssensor Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -applicationlist
{{ Fill applicationlist Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
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

### -data
{{ Fill data Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
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
Position: 21
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
Position: 22
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
