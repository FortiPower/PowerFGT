---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallProxyAddressGroup

## SYNOPSIS
Configure a FortiGate ProxyAddress Group

## SYNTAX

```
Set-FGTFirewallProxyAddressGroup [-addrgrp] <PSObject> [-name <String>] [-member <String[]>]
 [-comment <String>] [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate ProxyAddress Group (name, member, comment...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -member MyAddress1
```

Change MyFGTProxyAddressGroup member to MyAddress1

### EXAMPLE 2
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -member MyAddress1, MyAddress2
```

Change MyFGTProxyAddressGroup member to MyAddress1

### EXAMPLE 3
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup2
```

Rename MyFGTProxyAddressGroup member to MyFGTProxyAddressGroup2

### EXAMPLE 4
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTproxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -visibility:$false
```

Change MyFGTProxyAddressGroup to set a new comment and disabled visibility

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

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
