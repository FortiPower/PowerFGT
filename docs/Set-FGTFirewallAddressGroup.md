---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallAddressGroup

## SYNOPSIS
Configure a FortiGate Address Group

## SYNTAX

```
Set-FGTFirewallAddressGroup [-addrgrp] <PSObject> [-name <String>] [-member <String[]>] [-comment <String>]
 [-visibility <Boolean>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Address Group (name, member, comment...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -member MyAddress1
```

Change MyFGTAddressGroup member to MyAddress1

### EXAMPLE 2
```
$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -member MyAddress1, MyAddress2
```

Change MyFGTAddressGroup member to MyAddress1

### EXAMPLE 3
```
$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -name MyFGTAddressGroup2
```

Rename MyFGTAddressGroup member to MyFGTAddressGroup2

### EXAMPLE 4
```
$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -visibility:$false
```

Change MyFGTAddressGroup to set a new comment and disabled visibility

### EXAMPLE 5
```
$data = @{ "color" = 23 }
PS C:\>$MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -data $data
```

Change MyFGTAddressGroup to set color (23) using -data

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

### -data
{{ Fill data Description }}

```yaml
Type: Hashtable
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
