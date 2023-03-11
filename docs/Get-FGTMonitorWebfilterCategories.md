---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTMonitorWebfilterCategories

## SYNOPSIS
GetFortiGuard web filter categories

## SYNTAX

```
Get-FGTMonitorWebfilterCategories [-include_unrated] [-convert_unrated_id] [-skip] [[-vdom] <String[]>]
 [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get FortiGuard web filter categories (and unrated)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTMonitorWebfilterCategories
```

Get FortiGuard web filter categorie (name, group_id, group, rating)

### EXAMPLE 2
```
Get-FGTMonitorWebfilterCategories -include_unrated
```

Get FortiGuard web filter categories with unrated

## PARAMETERS

### -include_unrated
{{ Fill include_unrated Description }}

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

### -convert_unrated_id
{{ Fill convert_unrated_id Description }}

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
