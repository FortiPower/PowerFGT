---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Remove-FGTVpnIpsecPhase2Interface

## SYNOPSIS
Remove a Vpn IPsec Phase 2 Interface

## SYNTAX

```
Remove-FGTVpnIpsecPhase2Interface [-interface] <PSObject> [-vdom <String[]>] [-connection <PSObject>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a Vpn IPsec Phase 2 Interface

## EXAMPLES

### EXAMPLE 1
```
Get-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN | Remove-FGTVpnIpsecPhase2Interface
```

Removes the Vpn IPsec Phase 2 Interface ph2_PowerFGT_VPN which was retrieved with Get-FGTVpnIpsecPhase2Interface

### EXAMPLE 2
```
Get-FGTVpnIpsecPhase2Interfacee -name ph2_PowerFGT_VPN | Remove-FGTVpnIpsecPhase2Interfacee -Confirm:$false
```

Removes the Vpn IPsec Phase 2 Interface ph2_PowerFGT_VPN and suppresses the confirmation question

## PARAMETERS

### -interface
{{ Fill interface Description }}

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
