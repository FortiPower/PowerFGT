---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallLocalInPolicy

## SYNOPSIS
Add a FortiGate Local In Policy

## SYNTAX

```
Add-FGTFirewallLocalInPolicy [[-policyid] <Int32>] [-intf] <String[]> [-srcaddr] <String[]>
 [-dstaddr] <String[]> [[-action] <String>] [-status] [[-schedule] <String>] [[-service] <String[]>]
 [[-comments] <String>] [-skip] [[-data] <Hashtable>] [[-vdom] <String[]>] [[-connection] <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Local In Policy (interface, source/destination ip, service, action, status...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all
```

Add a Local In Policy with source port port1 and destination port2 and source and destination all

### EXAMPLE 2
```
Add-FGTFirewallLocalInPolicy -intf port10 -srcaddr all -dstaddr all -status:$false
```

Add a Local In Policy with status is disable

### EXAMPLE 3
```
Add-FGTFirewallLocalInPolicy  -intf port1 -srcaddr all -dstaddr all -service HTTP, HTTPS, SSH
```

Add a Local In Policy with multiple service port

### EXAMPLE 4
```
Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all -comments "My FGT Policy"
```

Add a Local In Policy with comment "My FGT Policy"

### EXAMPLE 5
```
Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all -policyid 23
```

Add a Local In Policy with Policy ID equal 23

### EXAMPLE 6
```
$data = @{ "virtual-patch" = "enable" }
Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all -data $data
```

Add a Local In Policy with virtual-patch using -data

## PARAMETERS

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

### -intf
{{ Fill intf Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
Default value: ALL
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
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
