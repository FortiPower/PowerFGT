---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallVipGroup

## SYNOPSIS
Configure a FortiGate VIP Group

## SYNTAX

```
Set-FGTFirewallVipGroup [-vipgrp] <PSObject> [-name <String>] [-member <String[]>] [-comments <String>]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate VIP Group (name, member, comments...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -member MyVip1
```

Change MyFGTVipGroup member to MyVip1

### EXAMPLE 2
```
$MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -member MyVip1, MyVip2
```

Change MyFGTVipGroup member to MyVip1 and MyVip2

### EXAMPLE 3
```
$MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -name MyFGTVipGroup2
```

Rename MyFGTVipGroup member to MyFGTVipGroup2

### EXAMPLE 4
```
$MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -comments "Modified by PowerFGT"
```

Change MyFGTVipGroup to set a new comments

## PARAMETERS

### -vipgrp
{{ Fill vipgrp Description }}

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

### -comments
{{ Fill comments Description }}

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
