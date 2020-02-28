---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Invoke-FGTRestMethod

## SYNOPSIS
Invoke RestMethod with FGT connection (internal) variable

## SYNTAX

### default (Default)
```
Invoke-FGTRestMethod [-uri] <String> [-method <String>] [-body <PSObject>] [-skip] [-vdom <String[]>]
 [-filter <String>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-connection <PSObject>] [<CommonParameters>]
```

### filter
```
Invoke-FGTRestMethod [-uri] <String> [-method <String>] [-body <PSObject>] [-skip] [-vdom <String[]>]
 [-filter <String>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-connection <PSObject>] [<CommonParameters>]
```

### filter_build
```
Invoke-FGTRestMethod [-uri] <String> [-method <String>] [-body <PSObject>] [-skip] [-vdom <String[]>]
 [-filter <String>] [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Invoke RestMethod with FGT connection variable (token, csrf..)

## EXAMPLES

### EXAMPLE 1
```
Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address"
```

Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri

### EXAMPLE 2
```
Invoke-FGTRestMethod "api/v2/cmdb/firewall/address"
```

Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri with default parameter

### EXAMPLE 3
```
Invoke-FGTRestMethod "-method "get" -uri api/v2/cmdb/firewall/address" -vdom vdomX
```

Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri on vdomX

### EXAMPLE 4
```
Invoke-FGTRestMethod --method "post" -uri "api/v2/cmdb/firewall/address" -body $body
```

Invoke-RestMethod with FGT connection for post api/v2/cmdb/firewall/address uri with $body payload

### EXAMPLE 5
```
Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address" -connection $fw2
```

Invoke-RestMethod with $fw2 connection for get api/v2/cmdb/firewall/address uri

### EXAMPLE 6
```
Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address" -filter=name==FGT
```

Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri with only name equal FGT

### EXAMPLE 7
```
Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address" -filter_attribute name -filter_value FGT
```

Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri with filter attribute equal name and filter value equal FGT

### EXAMPLE 8
```
Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address" -filter_attribute name -filter_type contains -filter_value FGT
```

Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri with filter attribute equal name and filter value contains FGT

## PARAMETERS

### -uri
{{ Fill uri Description }}

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

### -method
{{ Fill method Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -body
{{ Fill body Description }}

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

### -filter
{{ Fill filter Description }}

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
Default value: None
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

### -connection
{{ Fill connection Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
