---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Remove-FGTFirewallAddressGroupMember

## SYNOPSIS
Remove a FortiGate Address Group Member

## SYNTAX

```
Remove-FGTFirewallAddressGroupMember [-addrgrp] <PSObject> [-member <String[]>] [-vdom <String[]>]
 [-connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a FortiGate Address Group Member

## EXAMPLES

### EXAMPLE 1
```
$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroupMember -member MyAddress1
```

Remove MyAddress1 member to MyFGTAddressGroup

### EXAMPLE 2
```
$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroupMember -member MyAddress1, MyAddress2
```

Remove MyAddress1 and MyAddress2 member to MyFGTAddressGroup

## PARAMETERS

### -addrgrp
{{ Fill addrgrp Description }}

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

### -member
{{ Fill member Description }}

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
