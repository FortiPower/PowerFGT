---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTUserGroup

## SYNOPSIS
Configure a FortiGate User Group

## SYNTAX

```
Set-FGTUserGroup [-usergroup] <PSObject> [-name <String>] [-member <String[]>] [-data <Hashtable>]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate User Group (name, member...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserGroup = Get-FGTUserGroup -name MyFGTUserGroup
PS C:\>$MyFGTUserGroup | Set-FGTUserGroup -member MyUser1
```

Change MyFGTUserGroup member to MyUser1

### EXAMPLE 2
```
$MyFGTUserGroup = Get-FGTUserGroup -name MyFGTUserGroup
PS C:\>$MyFGTUserGroup | Set-FGTUserGroup -member MyUser1, MyUser2
```

Change MyFGTUserGroup member to MyUser1 and MyUser2

### EXAMPLE 3
```
$MyFGTUserGroup = Get-FGTUserGroup -name MyFGTUserGroup
PS C:\>$MyFGTUserGroup | Set-FGTUserGroup -name MyFGTUserGroup2
```

Rename MyFGTUserGroup member to MyFGTUserGroup2

### EXAMPLE 4
```
$data = @{ "authtimeout" = 23 }
PS C:\>$MyFGTUserGroup = Get-FGTUserGroup -name MyFGTUserGroup
PS C:\>$MyFGTUserGroup | Set-FGTUserGroup -data $data
```

Change MyFGTUserGroup to set authtimeout (23) using -data

## PARAMETERS

### -usergroup
{{ Fill usergroup Description }}

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
