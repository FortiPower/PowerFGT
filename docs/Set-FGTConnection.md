---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTConnection

## SYNOPSIS
Configure FGT connection Setting

## SYNTAX

```
Set-FGTConnection [[-vdom] <String[]>] [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Configure FGT connection Setting (Vdom...)

## EXAMPLES

### EXAMPLE 1
```
Set-FGTConnection -vdom vdomY
```

Configure default connection vdom to vdomY

### EXAMPLE 2
```
Set-FGTConnection -vdom $null
```

Restore vdom configuration to default (by default root)

## PARAMETERS

### -vdom
{{ Fill vdom Description }}

```yaml
Type: String[]
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
