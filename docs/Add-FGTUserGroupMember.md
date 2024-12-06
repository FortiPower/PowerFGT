---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTUserGroupMember

## SYNOPSIS
Add a FortiGate User Group Member

## SYNTAX

```
Add-FGTUserGroupMember [-usergroup] <PSObject> [-member <String[]>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate User Group Member

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserGroup = Get-FGTUserGroup -name MyFGTUserGroup
PS C:\>$MyFGTUserGroup | Add-FGTUserGroupMember -member MyUser1
```

Add MyUser1 member to MyFGTUserGroup

### EXAMPLE 2
```
$MyFGTUserGroup = Get-FGTUserGroup -name MyFGTUserGroup
PS C:\>$MyFGTUserGroup | Add-FGTUserGroupMember -member MyUser1, MyUser2
```

Add MyUser1 and MyUser2 member to MyFGTUserGroup

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
