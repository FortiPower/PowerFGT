---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTSystemVirtualWANLink

## SYNOPSIS
Get Virtual Wan Link (SD-WAN) Settings

## SYNTAX

### default (Default)
```
Get-FGTSystemVirtualWANLink [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### filter
```
Get-FGTSystemVirtualWANLink [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-skip] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get Virtual Wan Link Settings (status, load balance mode, members, health-check...
)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTSystemVirtualWANLink
```

Get Virtual Wan Link Settings

### EXAMPLE 2
```
Get-FGTSystemVirtualWANLink -filter_attribute status -filter_value enable
```

Get Virtual Wan Link with mode equal standalone

### EXAMPLE 3
```
Get-FGTSystemHA -filter_attribute load-balance-mode -filter_value ip -filter_type contains
```

Get Virtual Wan Link with load-balance-modecontains ip

### EXAMPLE 4
```
Get-FGTSystemVirtualWANLink -skip
```

Get Virtual Wan Link Settings (but only relevant attributes)

### EXAMPLE 5
```
Get-FGTSystemVirtualWANLink -vdom vdomX
```

Get Virtual Wan Link Settings on vdomX

## PARAMETERS

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
