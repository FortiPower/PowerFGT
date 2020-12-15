---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallVipGroup

## SYNOPSIS
Add a FortiGate VIP Group

## SYNTAX

```
Add-FGTFirewallVipGroup [-name] <String> [-member] <String[]> [[-interface] <String>] [[-comments] <String>]
 [[-vdom] <String[]>] [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate VIP Group

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallVipGroup -name MyVipGroup -member MyVip1 -interface wan1
```

Add VIP Group with member MyVip1, associated to interface wan1

### EXAMPLE 2
```
Add-FGTFirewallVipGroup -name MyVipGroup -member MyVip1, MyVip2 -interface wan1
```

Add VIP Group with members MyVip1 and MyVip2, associated to interface wan1

### EXAMPLE 3
```
Add-FGTFirewallVipGroup -name MyVipGroup -member MyVip1 -comments "My VIP Group" -interface wan1
```

Add VIP Group with member MyVip1 and a comments, associated to interface wan1

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

### -member
{{ Fill member Description }}

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

### -interface
{{ Fill interface Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Any
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
Position: 4
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
Position: 5
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
Position: 6
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
