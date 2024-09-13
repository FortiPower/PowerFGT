---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Remove-FGTUserLDAP

## SYNOPSIS
Remove a FortiGate LDAP Server

## SYNTAX

```
Remove-FGTUserLDAP [-userldap] <PSObject> [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a LDAP Server on the FortiGate

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserLDAP = Get-FGTUserLDAP -name PowerFGT
PS C:\>$MyFGTUserLDAP | Remove-FGTUserLDAP
```

Remove user object $MyFGTUserLDAP

### EXAMPLE 2
```
$MyFGTUserLDAP = Get-FGTUserLDAP -name MyFGTUserLDAP
PS C:\>$MyFGTUserLDAP | Remove-FGTUserLDAP -confirm:$false
```

Remove UserLDAP object $MyFGTUserLDAP with no confirmation

## PARAMETERS

### -userldap
{{ Fill userldap Description }}

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
