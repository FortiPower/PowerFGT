---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallProxyAddressGroupMember

## SYNOPSIS
Add a FortiGate ProxyAddress Group Member

## SYNTAX

```
Add-FGTFirewallProxyAddressGroupMember [-addrgrp] <PSObject> [-member <String[]>] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate ProxyAddress Group Member

## EXAMPLES

### EXAMPLE 1
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTproxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Add-FGTFirewallProxyAddressGroupMember -member MyAddress1
```

Add MyAddress1 member to MyFGTproxyAddressGroup

### EXAMPLE 2
```
$MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
PS C:\>$MyFGTProxyAddressGroup | Add-FGTFirewallProxyAddressGroupMember -member MyAddress1, MyAddress2
```

Add MyAddress1 and MyAddress2 member to MyFGTProxyAddressGroup

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

### -member
{{ Fill member Description }}

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
