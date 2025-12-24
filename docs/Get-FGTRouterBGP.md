---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTRouterBGP

## SYNOPSIS
Get list of all BGP

## SYNTAX

### default (Default)
```
Get-FGTRouterBGP [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### schema
```
Get-FGTRouterBGP [-meta] [-skip] [-schema] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all BGP (AS, router-id, neighbor, network...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTRouterBGP
```

Get list of all router BGP object

### EXAMPLE 2
```
Get-FGTRouterBGP -meta
```

Get list of all router BGP object with metadata (q_...) like usage (q_ref)

### EXAMPLE 3
```
Get-FGTRouterBGP -skip
```

Get list of all router BGP object (but only relevant attributes)

### EXAMPLE 4
```
Get-FGTRouterBGP -schema
```

Get schema of Router BGP

### EXAMPLE 5
```
Get-FGTRouterBGP -vdom vdomX
```

Get list of all router BGP object on vdomX

## PARAMETERS

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
