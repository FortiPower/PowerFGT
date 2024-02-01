---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallProxyAddressGroup

## SYNOPSIS
Add a FortiGate ProxyAddress Group

## SYNTAX

```
Add-FGTFirewallProxyAddressGroup [-type] <String> [-name] <String> [-member] <String[]> [[-comment] <String>]
 [[-visibility] <Boolean>] [[-vdom] <String[]>] [[-connection] <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate ProxyAddress Group

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallProxyAddressGroup -type src -name MyAddressGroup -member MyAddress1
```

Add ProxyAddress Group with type source and member MyAddress1 (type host-regex or method)

### EXAMPLE 2
```
Add-FGTFirewallProxyAddressGroup -type src -name MyAddressGroup -member MyAddress1, MyAddress2
```

Add ProxyAddress Group with type source and members MyAddress1 and MyAddress2 (type host-regex or method)

### EXAMPLE 3
```
Add-FGTFirewallProxyAddressGroup -type dst -name MyAddressGroup -member MyAddress1 -comment "My ProxyAddress Group"
```

Add ProxyAddress Group with type destination and member MyAddress1 (type path) and a comment

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

### -member
{{ Fill member Description }}

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

### -comment
{{ Fill comment Description }}

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

### -visibility
{{ Fill visibility Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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
Position: 7
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
