---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Copy-FGTFirewallProxyAddressGroup

## SYNOPSIS
Copy/Clone a FortiGate ProxyAddress Group

## SYNTAX

```
Copy-FGTFirewallProxyAddressGroup [-addrgrp] <PSObject> -name <String> [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Copy/Clone a FortiGate ProxyAddress Group (name, member...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Copy-FGTProxyFirewallAddressGroup -name MyFGTProxyAddressGroup_copy
```

Copy / Clone MyFGTproxyAddressGroup with new name MyFGTProxyAddressGroup_copy

## PARAMETERS

### -addrgrp
{{ Fill addrgrp Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

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
