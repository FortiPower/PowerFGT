---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTMonitorFirewallSession

## SYNOPSIS
Get Monitor Firewall Session

## SYNTAX

```
Get-FGTMonitorFirewallSession [-summary] [[-policyid] <Int32>] [[-count] <Int32>] [-skip] [[-vdom] <String[]>]
 [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get Monitor Firewall Session (proto, source/destination IP/Port, policyid ...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTMonitorFirewallSession
```

Get ALL Firewall Policy session (by default 20 first session)

### EXAMPLE 2
```
Get-FGTMonitorFirewallSession -count 1000
```

Get 1000 Firewall Session monitor

### EXAMPLE 3
```
Get-FGTMonitorFirewallSession -policyid 23
```

Get Firewall Session monitor with id 23

### EXAMPLE 4
```
Get-FGTMonitorFirewallSession -vdom vdomX
```

Get Firewall Session monitor of vdomX

## PARAMETERS

### -summary
{{ Fill summary Description }}

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

### -policyid
{{ Fill policyid Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -count
{{ Fill count Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 20
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
Position: 3
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
Position: 4
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
