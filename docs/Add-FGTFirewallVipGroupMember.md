---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallVipGroupMember

## SYNOPSIS
Add a FortiGate VIP Group Member

## SYNTAX

```
Add-FGTFirewallVipGroupMember [-vipgrp] <PSObject> [-member <String[]>] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate VIP Group Member

## EXAMPLES

### EXAMPLE 1
```
$MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
PS C:\>$MyFGTVipGroup | Add-FGTFirewallVipGroupMember -member MyVip1
```

Add MyVip1 member to MyFGTVipGroup

### EXAMPLE 2
```
$MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
PS C:\>$MyFGTVipGroup | Add-FGTFirewallVipGroupMember -member MyVip1, MyVip2
```

Add MyVip1 and MyVip2 member to MyFGTVipGroup

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
