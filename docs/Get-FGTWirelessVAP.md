---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTWirelessVAP

## SYNOPSIS
Get list of Wireless VAP (Virtual AP Profile) Settings

## SYNTAX

### default (Default)
```
Get-FGTWirelessVAP [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### name
```
Get-FGTWirelessVAP [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTWirelessVAP [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get list of Wireless VAP (Virtual AP Profile) Settings (Name, SSID, Security ...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTWirelessVAP
```

Get list of Wireless VAP (Virtual AP Profile) object

### EXAMPLE 2
```
Get-FGTWirelessVAP -name MyVAP
```

Get list of Wireless VAP (Virtual AP Profile) object named MyVAP

### EXAMPLE 3
```
Get-FGTWirelessVAP -meta
```

Get list of Wireless VAP (Virtual AP Profile) object with metadata (q_...) like usage (q_ref)

### EXAMPLE 4
```
Get-FGTWirelessVAP -skip
```

Get list of Wireless VAP (Virtual AP Profile) object (but only relevant attributes)

### EXAMPLE 5
```
Get-FGTWirelessVAP -vdom vdomX
```

Get list of Wireless VAP (Virtual AP Profile) object on vdomX

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_attribute
{{ Fill filter_attribute Description }}

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

### -filter_type
{{ Fill filter_type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Equal
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_value
{{ Fill filter_value Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -meta
{{ Fill meta Description }}

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

### -skip
Ignores the specified number of objects and then gets the remaining objects.
Enter the number of objects to skip.

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
