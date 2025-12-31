---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTFirewallLocalInPolicy

## SYNOPSIS
Configure a FortiGate Local In Policy

## SYNTAX

```
Set-FGTFirewallLocalInPolicy [-policy] <PSObject> [-name <String>] [-intf <String[]>] [-srcaddr <String[]>]
 [-dstaddr <String[]>] [-action <String>] [-status] [-schedule <String>] [-service <String[]>] [-nat]
 [-comments <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Local in Policy Policy/Rules (source/destination ip, interface, action, status, ...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -intf port1 -srcaddr MyFGTAddress
```

Change MyFGTPolicy (Policy id 23) to intf port1 and srcaddr MyFGTAddress

### EXAMPLE 2
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -service HTTP,HTTPS
```

Change MyFGTPolicy (Policy id 23) to set service to HTTP and HTTPS

### EXAMPLE 3
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -comments "My FGT Policy"
```

Change MyFGTPolicy (Policy id 23) to set a new comments

### EXAMPLE 4
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -status:$false
```

Change MyFGTPolicy (Policy id 23) to set status disable

### EXAMPLE 5
```
$data = @{"virtual-patch"  = "enable" }
PS C:\>$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -data $data
```

Change MyFGTPolicy (Policy id 23) to setvirtual-patch to enabled using -data

## PARAMETERS

### -policy
{{ Fill policy Description }}

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

### -intf
{{ Fill intf Description }}

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

### -srcaddr
{{ Fill srcaddr Description }}

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

### -dstaddr
{{ Fill dstaddr Description }}

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

### -status
{{ Fill status Description }}

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

### -schedule
{{ Fill schedule Description }}

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

### -service
{{ Fill service Description }}

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

### -nat
{{ Fill nat Description }}

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

### -comments
{{ Fill comments Description }}

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

### -data
{{ Fill data Description }}

```yaml
Type: Hashtable
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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
