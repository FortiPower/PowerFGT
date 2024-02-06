---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTSystemZone

## SYNOPSIS
Add a zone

## SYNTAX

```
Add-FGTSystemZone [-name] <String> [-intrazone <String>] [-interfaces <String[]>] [-description <String>]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Add a zone (name, intrazone, member...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTSystemZone -name myPowerFGTZone -intrazone allow -interfaces port5
```

Add a zone named myPowerFGTZone with intra-zone traffic Allow and with port5

### EXAMPLE 2
```
Add-FGTSystemZone -name myPowerFGTZone -intrazone deny -interfaces port5,port6
```

Add a zone named myPowerFGTZone with intra-zone traffic blocked and with port5 and port6 in this zone

### EXAMPLE 3
```
Add-FGTSystemZone -name myPowerFGTZone -intrazone deny -interfaces port6 -description "My Zone"
```

Add a zone named myPowerFGTZone with intra-zone traffic Allow and with port6 with a description (need FortiOS \>= 6.2.x for this)

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
