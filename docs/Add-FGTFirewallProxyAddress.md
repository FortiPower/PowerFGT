---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallProxyAddress

## SYNOPSIS
Add a FortiGate ProxyAddress

## SYNTAX

### default (Default)
```
Add-FGTFirewallProxyAddress -name <String> [-comment <String>] [-visibility <Boolean>] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

### host-regex
```
Add-FGTFirewallProxyAddress -name <String> [-hostregex <String>] [-comment <String>] [-visibility <Boolean>]
 [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### url
```
Add-FGTFirewallProxyAddress -name <String> [-path <String>] [-hostObjectName <String>] [-comment <String>]
 [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

### method
```
Add-FGTFirewallProxyAddress -name <String> [-method <String>] [-hostObjectName <String>] [-comment <String>]
 [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate ProxyAddress (host-regex, url ...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallProxyAddress -name FGT -hostregex '.*\.fortinet\.com'
```

Add ProxyAddress object type host-regex with name FGT and value '.*\.fortinet\.com'

### EXAMPLE 2
```
Add-FGTFirewallProxyAddress -Name FGT -method get -hostObjectName MyFGTAddress -comment "Get-only allowed to MyFGTAddress"
```

Add ProxyAddress object type method with name FGT, only allow method GET to MyHost and a comment

### EXAMPLE 3
```
Add-FGTFirewallProxyAddress -name FGT -hostObjectName fortipower.github.io -path '/PowerFGT' -visibility:$false
```

Add ProxyAddress object type url with name FGT, only allow path '/PowerFGT' to fortipower.github.io and disabled visibility

Todo: add the Category, UA and Header types

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostregex
{{ Fill hostregex Description }}

```yaml
Type: String
Parameter Sets: host-regex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -path
{{ Fill path Description }}

```yaml
Type: String
Parameter Sets: url
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -method
{{ Fill method Description }}

```yaml
Type: String
Parameter Sets: method
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostObjectName
{{ Fill hostObjectName Description }}

```yaml
Type: String
Parameter Sets: url, method
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -comment
{{ Fill comment Description }}

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

### -visibility
{{ Fill visibility Description }}

```yaml
Type: Boolean
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
