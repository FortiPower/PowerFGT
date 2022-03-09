---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTLogTraffic

## SYNOPSIS
Get Log Traffic

## SYNTAX

### default (Default)
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### srcip
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### srcintf
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### dstip
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### dstinf
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### dstport
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### action
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### policyid
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### poluuid
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### filter
```
Get-FGTLogTraffic [-type] <String> [-subtype] <String> [-rows <Int32>] [-srcip <String>] [-srcintf <String>]
 [-dstip <String>] [-dstintf <String>] [-dstport <Int32>] [-action <String>] [-policyid <Int32>]
 [-poluuid <Guid>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get Log Traffic(disk, fortianalyzer, memory...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTLogTraffic -type forticloud -subtype local
```

Get Log Traffic from forticloud on subtype local

### EXAMPLE 2
```
Get-FGTLogTraffic -type memory -subtype forward -rows 10000
```

Get Log Traffic from memory on subtype forward and 10 000 rows

### EXAMPLE 3
```
Get-FGTLogTraffic -type disk -subtype forward -rows 10000 -srcip
```

Get Log Traffic from memory on subtype forward and 10 000 rows

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

### -srcip
{{ Fill srcip Description }}

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

### -srcintf
{{ Fill srcintf Description }}

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

### -dstip
{{ Fill dstip Description }}

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

### -dstintf
{{ Fill dstintf Description }}

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

### -dstport
{{ Fill dstport Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -action
{{ Fill action Description }}

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

### -policyid
{{ Fill policyid Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -poluuid
{{ Fill poluuid Description }}

```yaml
Type: Guid
Parameter Sets: (All)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
