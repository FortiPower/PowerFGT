---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Disconnect-FGT

## SYNOPSIS
Disconnect a FortiGate

## SYNTAX

```
Disconnect-FGT [-noconfirm] [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Disconnect the connection of FortiGate

## EXAMPLES

### EXAMPLE 1
```
Disconnect-FGT
```

Disconnect the connection

### EXAMPLE 2
```
Disconnect-FGT -noconfirm
```

Disconnect the connection with no confirmation

## PARAMETERS

### -noconfirm
{{ Fill noconfirm Description }}

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

### -connection
{{ Fill connection Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
