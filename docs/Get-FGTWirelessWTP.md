---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTWirelessWTP

## SYNOPSIS
Get list of Wireless WTP (Wireless Termination Points) Settings

## SYNTAX

### default (Default)
```
Get-FGTWirelessWTP [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### name
```
Get-FGTWirelessWTP [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### wtpid
```
Get-FGTWirelessWTP [-wtp_id <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### uuid
```
Get-FGTWirelessWTP [-uuid <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTWirelessWTP [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### schema
```
Get-FGTWirelessWTP [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-schema] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get list of Wireless WTP (Wireless Termination Points) Settings (wtp-id, name, location ...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTWirelessWTP
```

Get list of Wireless WTP (Wireless Termination Points) object

### EXAMPLE 2
```
Get-FGTWirelessWTP -name MyWTP
```

Get list of Wireless WTP (Wireless Termination Points) object named MyWTP

### EXAMPLE 3
```
Get-FGTWirelessWTP -uuid c205fed0-da29-51ef-6218-233026636d1f
```

Get list of Wireless WTP (Wireless Termination Points) object with uuid c205fed0-da29-51ef-6218-233026636d1f

### EXAMPLE 4
```
Get-FGTWirelessWTP -wtp_id FP231FTF23026383
```

Get list of Wireless WTP (Wireless Termination Points) with wtp-id FP231FTF23026383

### EXAMPLE 5
```
Get-FGTWirelessWTP -meta
```

Get list of Wireless WTP (Wireless Termination Points) object with metadata (q_...) like usage (q_ref)

### EXAMPLE 6
```
Get-FGTWirelessWTP -skip
```

Get list of Wireless WTP (Wireless Termination Points) object (but only relevant attributes)

### EXAMPLE 7
```
Get-FGTWirelessWTP -schema
```

Get schema of Wireless WTP

### EXAMPLE 8
```
Get-FGTWirelessWTP -vdom vdomX
```

Get list of Wireless WTP (Wireless Termination Points) object on vdomX

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

### -wtp_id
{{ Fill wtp_id Description }}

```yaml
Type: String
Parameter Sets: wtpid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uuid
{{ Fill uuid Description }}

```yaml
Type: String
Parameter Sets: uuid
Aliases:

Required: False
Position: Named
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

### -schema
{{ Fill schema Description }}

```yaml
Type: SwitchParameter
Parameter Sets: schema
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
