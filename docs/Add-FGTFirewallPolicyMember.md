---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTFirewallPolicyMember

## SYNOPSIS
Add a FortiGate Policy Member

## SYNTAX

```
Add-FGTFirewallPolicyMember [-policy] <PSObject> [-srcaddr <String[]>] [-dstaddr <String[]>] [-vdom <String[]>]
 [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Policy Member (source or destination address)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -srcaddr MyAddress1
```

Add MyAddress1 member to source of MyFGTPolicy

### EXAMPLE 2
```
$MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -dstaddr MyAddress1, MyAddress2
```

Add MyAddress1 and MyAddress2 member to destination of MyFGTPolicy

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
