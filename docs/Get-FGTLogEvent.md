---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTLogEvent

## SYNOPSIS
Get Log Event

## SYNTAX

### default (Default)
```
Get-FGTLogEvent [-type] <String> [-subtype] <String> [-rows <Int32>] [-extra <String[]>] [-since <String>]
 [-wait <Int32>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTLogEvent [-type] <String> [-subtype] <String> [-rows <Int32>] [-extra <String[]>] [-since <String>]
 [-wait <Int32>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get Log Event (disk, fortianalyzer, memory...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTLogEvent -type forticloud -subtype local
```

Get Log Event from forticloud on subtype local

### EXAMPLE 2
```
Get-FGTLogEvent -type memory -subtype vpn -rows 10000
```

Get Log Event from memory on subtype vpn with 10 000 rows

### EXAMPLE 3
```
Get-FGTLogEvent -type disk -subtype user -rows 10000
```

Get Log Event from disk on subtype user with 10 000 rows

### EXAMPLE 4
```
Get-FGTLogEvent -type fortianalyzer -subtype system -rows 10000 -since 7d
```

Get Log Event from fortianalyzer on subtype system with 10 000 rows since 7 day

### EXAMPLE 5
```
Get-FGTLogEvent -type disk -subtype vpn -rows 10000 -extra reverse_lookup
```

Get Log Event from disk on subtype vpn with 10 000 rows with reverse lookup

### EXAMPLE 6
```
Get-FGTLogEvent -type fortianalyzer -subtype system -rows 10000 -wait 5000
```

Get Log Event from fortianalyzer on subtype system with 10 000 rows and wait 5000 Milliseconds between each request

## PARAMETERS

### -type
{{ Fill type Description }}

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

### -subtype
{{ Fill subtype Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rows
{{ Fill rows Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -extra
{{ Fill extra Description }}

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

### -since
{{ Fill since Description }}

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

### -wait
{{ Fill wait Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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
