---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTDnsfilterProfile

## SYNOPSIS
Get list of all Dnsfilter Profile settings

## SYNTAX

### default (Default)
```
Get-FGTDnsfilterProfile [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### name
```
Get-FGTDnsfilterProfile [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTDnsfilterProfile [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-meta]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all Dnsfilter Profile (name, sdns, ftgd-dns ...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTDnsfilterProfile
```

Get list of all settings of Dnsfilter Profile

### EXAMPLE 2
```
Get-FGTDnsfilterProfile -name myDnsfilterProfile
```

Get Dnsfilter Profile named myDnsfilterProfile

### EXAMPLE 3
```
Get-FGTDnsfilterProfile -name FGT -filter_type contains
```

Get Dnsfilter Profile contains with *FGT*

### EXAMPLE 4
```
Get-FGTDnsfilterProfile -meta
```

Get list of all settings of Dnsfilter Profile with metadata (q_...) like usage (q_ref)

### EXAMPLE 5
```
Get-FGTDnsfilterProfile -skip
```

Get list of all settings of Dnsfilter Profile (but only relevant attributes)

### EXAMPLE 6
```
Get-FGTDnsfilterProfile -vdom vdomX
```

Get list of all settings of Dnsfilter Profile on vdomX

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
