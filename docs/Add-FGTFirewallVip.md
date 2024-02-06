---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallVip

## SYNOPSIS
Add a FortiGate Virtual IP

## SYNTAX

```
Add-FGTFirewallVip [-type] <String> [-name] <String> [-extip] <IPAddress> [-mappedip] <IPAddress>
 [[-interface] <String>] [[-comment] <String>] [-portforward] [[-protocol] <String>] [[-extport] <String>]
 [[-mappedport] <String>] [[-arpreply] <Boolean>] [[-data] <Hashtable>] [-skip] [[-vdom] <String[]>]
 [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Virtual IP (VIP) (One to One)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTFirewallVip -name myVIP1 -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1
```

Add VIP objet type static-nat (One to One) with name myVIP1 with external IP 192.0.2.1 and mapped IP 198.51.100.1

### EXAMPLE 2
```
Add-FGTFirewallVip -name myVIP2 -type static-nat -extip 192.0.2.2 -mappedip 198.51.100.2 -interface port1 -comment "My FGT VIP"
```

Add VIP objet type static-nat (One to One) with name myVIP1 with external IP 192.0.2.1, mapped IP 198.51.100.1, associated to interface port2 and a comment

### EXAMPLE 3
```
Add-FGTFirewallVip -name myVIP3-8080 -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1 -portforward -extport 8080
```

Add VIP objet type static-nat (One to One) with name myVIP3 with external IP 192.0.2.1 and mapped IP 198.51.100.1 with Port Forward and TCP Port 8080

### EXAMPLE 4
```
Add-FGTFirewallVip -name myVIP4-5000-6000 -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1 -portforward -extport 5000 -mappedport 6000 -protocol udp
```

Add VIP objet type static-nat (One to One) with name myVIP4 with external IP 192.0.2.1 and mapped IP 198.51.100.1 with Port Forward and UDP Port 5000 mapped to port 6000

### EXAMPLE 5
```
$data = @{ "nat-source-vip" = "enable" ; "color" = "23"}
PS C> Add-FGTFirewallVip -name myVIP5-data -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1 -data $data
```

Add VIP objet type static-nat (One to One) with name myVIP5 with nat-source-vip and color settings using -data parameter

## PARAMETERS

### -type
{{ Fill type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -name
{{ Fill name Description }}

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

### -extip
{{ Fill extip Description }}

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mappedip
{{ Fill mappedip Description }}

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
Position: 5
Default value: Any
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
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -portforward
{{ Fill portforward Description }}

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

### -protocol
{{ Fill protocol Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Tcp
Accept pipeline input: False
Accept wildcard characters: False
```

### -extport
{{ Fill extport Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mappedport
{{ Fill mappedport Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -arpreply
{{ Fill arpreply Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -data
{{ Fill data Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
Position: 12
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
Position: 13
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
