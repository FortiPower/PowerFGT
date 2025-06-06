---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallServiceGroup

## SYNOPSIS
Configure a FortiGate Service Group

## SYNTAX

```
Set-FGTFirewallServiceGroup [-servgrp] <PSObject> [-name <String>] [-member <String[]>] [-comment <String>]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Service Group (name, member, comment...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -member MyService1
```

Change MyFGTServiceGroup member to MyService1

### EXAMPLE 2
```
$MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -member MyService1, MyService2
```

Change MyFGTServiceGroup member to MyService1

### EXAMPLE 3
```
$MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -name MyFGTServiceGroup2
```

Rename MyFGTServiceGroup member to MyFGTServiceGroup2

### EXAMPLE 4
```
$data = @{ "color" = 23 }
PS C:\>$MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -data $data
```

Change MyFGTServiceGroup to set color (23) using -data

## PARAMETERS

### -servgrp
{{ Fill servgrp Description }}

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
