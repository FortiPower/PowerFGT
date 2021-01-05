---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTSystemZoneMember

## SYNOPSIS
Add a zone member

## SYNTAX

```
Add-FGTSystemZoneMember [-zone] <PSObject> -interfaces <String[]> [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION
Add a zone member interface

## EXAMPLES

### EXAMPLE 1
```
Get-FGTSystemZone myPowerFGTZone | Add-FGTSystemZoneMember -interface port9
```

Add the zone named myPowerFGTZone member interface port9

### EXAMPLE 2
```
Get-FGTSystemZone myPowerFGTZone | Add-FGTSystemZoneMember -interface port8, port9
```

Add the zone named myPowerFGTZone member interface port8 and port9

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

### -interfaces
{{ Fill interfaces Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
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
