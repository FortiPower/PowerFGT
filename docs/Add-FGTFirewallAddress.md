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

```
Add-FGTFirewallAddress [-type] <String> [-name] <String> [[-ip] <IPAddress>] [[-mask] <IPAddress>]
 [[-interface] <String>] [[-comment] <String>] [[-visibility] <Boolean>] [[-vdom] <String[]>]
 [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Address (ipmask, fqdn, widlcard...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0
```

Add Address objet type ipmask with name FGT and value 192.2.0.0/24

### EXAMPLE 2
```
Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -interface port2
```

Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and associated to interface port2

### EXAMPLE 3
```
Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -comment "My FGT Address"
```

Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and a comment

### EXAMPLE 4
```
Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -visibility:$false
```

Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and disabled visibility

## PARAMETERS

### -type
{{ Fill type Description }}

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

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ip
{{ Fill ip Description }}

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mask
{{ Fill mask Description }}

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
