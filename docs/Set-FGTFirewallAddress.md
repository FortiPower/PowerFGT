---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallAddress

## SYNOPSIS
Configure a FortiGate Address

## SYNTAX

```
Set-FGTFirewallAddress [-address] <PSObject> [-name <String>] [-ip <IPAddress>] [-mask <IPAddress>]
 [-interface <String>] [-comment <String>] [-visibility <Boolean>] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Address (ip, mask, comment, associated interface...
)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
```

PS C:\\\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.2.0.0 -mask 255.255.255.0

Change MyFGTAddress to value (ip and mask) 192.2.0.0/24

### EXAMPLE 2
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
```

PS C:\\\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.2.2.1

Change MyFGTAddress to value (ip) 192.2.2.1

### EXAMPLE 3
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
```

PS C:\\\>$MyFGTAddress | Set -interface port1

Change MyFGTAddress to set associated interface to port 1

### EXAMPLE 4
```
$MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
```

PS C:\\\>$MyFGTAddress | Set -comment "My FGT Address" -visibility:$false

Change MyFGTAddress to set a new comment and disabled visibility

## PARAMETERS

### -address
{{ Fill address Description }}

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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ip
{{ Fill ip Description }}

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mask
{{ Fill mask Description }}

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -interface
{{ Fill interface Description }}

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
