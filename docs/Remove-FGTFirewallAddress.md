---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Remove-FGTFirewallAddress

## SYNOPSIS
Remove a FortiGate Address

## SYNTAX

```
Remove-FGTFirewallAddress [-address] <PSObject> [-noconfirm] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION
Remove an address object on the FortiGate

## EXAMPLES

### EXAMPLE 1
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
```

PS C:\\\>$MyFGTAddress | Remove-FGTFirewallAddress

Remove address object $MyFGTAddress

### EXAMPLE 2
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
```

PS C:\\\>$MyFGTAddress | Remove-FGTFirewallAddress -noconfirm

Remove address object $MyFGTAddress with no confirmation

## PARAMETERS

### -address
{{ Fill address Description }}

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

### -noconfirm
{{ Fill noconfirm Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
