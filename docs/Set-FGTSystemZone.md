---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTSystemZone

## SYNOPSIS
Set a zone

## SYNTAX

```
Set-FGTSystemZone [-zone] <PSObject> [-name <String>] [-intrazone <String>] [-description <String>]
 [-interfaces <String[]>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Configure a zone (name, intrazone, member...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -intrazone deny
```

Set the zone named myPowerFGTZone with intra-zone traffic deny

### EXAMPLE 2
```
Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -interfaces port5, port6
```

Set the zone named myPowerFGTZone with port 5 and port 6 bound to it

### EXAMPLE 3
```
Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -name new_myPowerFGTZone
```

Set the zone named myPowerFGTZone with new name new_myPowerFGTZone

### EXAMPLE 4
```
Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -name new_myPowerFGTZone
```

Set the zone named myPowerFGTZone with new name new_myPowerFGTZone

## PARAMETERS

### -zone
{{ Fill zone Description }}

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

### -intrazone
{{ Fill intrazone Description }}

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

### -description
{{ Fill description Description }}

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

### -interfaces
{{ Fill interfaces Description }}

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
