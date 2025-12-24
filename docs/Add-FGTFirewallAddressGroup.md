---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallAddressGroup

## SYNOPSIS
Add a FortiGate Address Group

## SYNTAX

```
Add-FGTFirewallAddressGroup [-name] <String> [[-member] <String[]>] [[-comment] <String>]
 [[-visibility] <Boolean>] [[-data] <Hashtable>] [[-vdom] <String[]>] [[-connection] <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Address Group

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1
```

Add Address Group with member MyAddress1

### EXAMPLE 2
```
Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1, MyAddress2
```

Add Address Group with members MyAddress1 and MyAddress2

### EXAMPLE 3
```
Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1 -comment "My Address Group"
```

Add Address Group with member MyAddress1 and a comment

### EXAMPLE 4
```
$data = @{ "color" = 23 }
PS C:\>Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1 -comment "My Address Group" -data $data
```

Add Address Group with member MyAddress1, a comment and color (23) via -data parameter

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

Required: False
Position: 2
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
Position: 3
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
Position: 4
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
Position: 5
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
