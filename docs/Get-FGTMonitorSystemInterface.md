---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTMonitorSystemInterface

## SYNOPSIS
Get System Interface

## SYNTAX

```
Get-FGTMonitorSystemInterface [-include_vlan] [-include_aggregate] [[-scope] <String>]
 [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get System Interface (status, alias, speed, tx/rx packets/bytes...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTMonitorSystemInterface
```

Get System Interface

### EXAMPLE 2
```
Get-FGTMonitorSystemInterface -include_vlan
```

Get System Interface with vlan information

### EXAMPLE 3
```
Get-FGTMonitorSystemInterface -include_aggregate
```

Get System Interface with aggregate interface information

### EXAMPLE 4
```
Get-FGTMonitorSystemInterface -scope vdom
```

Get System Interface from scope vdom

## PARAMETERS

### -include_vlan
{{ Fill include_vlan Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -include_aggregate
{{ Fill include_aggregate Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -scope
{{ Fill scope Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 2
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
