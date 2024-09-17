---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTUserRADIUS

## SYNOPSIS
Add a FortiGate RADIUS Server

## SYNTAX

```
Add-FGTUserRADIUS [-name] <String> [-server] <String> [-secret] <SecureString> [[-secondary_server] <String>]
 [[-secondary_secret] <SecureString>] [[-tertiary_server] <String>] [[-tertiary_secret] <SecureString>]
 [[-timeout] <Int32>] [[-nas_ip] <String>] [[-auth_type] <String>] [[-nas_id] <String>] [[-data] <Hashtable>]
 [[-vdom] <String[]>] [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate RADIUS Server

## EXAMPLES

### EXAMPLE 1
```
$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret
```

Add a RADIUS Server with radius.powerfgt as server and secret

### EXAMPLE 2
```
$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -secondary_server radius2.powerfgt -secondary_secret $mysecret -tertiary_server radius3.powerfgt -tertiary_secret $mysecret
```

Add a RADIUS Server with radius.powerfgt as server and secret, and secondary and tertiary servers

### EXAMPLE 3
```
$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -timeout 5
```

Add a RADIUS Server with radius.powerfgt as server and secret and timeout to 5 seconds

### EXAMPLE 4
```
$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -nas_ip 192.0.2.1
```

Add a RADIUS Server with radius.powerfgt as server and secret and NAS IP as 192.0.2.1

### EXAMPLE 5
```
$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -nas_id PowerFGT_RADIUS
```

Add a RADIUS Server with radius.powerfgt as server and secret and NAS ID as PowerFGT_RADIUS

### EXAMPLE 6
```
$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -auth_type ms_chap_v2
```

Add a RADIUS Server with radius.powerfgt as server and secret and auth_type as ms_chap_v2

### EXAMPLE 7
```
$data = @{ "password-renewal" = "enable" }
PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -data $data
```

Add a RADIUS Server with radius.powerfgt as server and secret and password renewal enabled

## PARAMETERS

### -name
{{ Fill name Description }}

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

### -server
{{ Fill server Description }}

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

### -secret
{{ Fill secret Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secondary_server
{{ Fill secondary_server Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secondary_secret
{{ Fill secondary_secret Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tertiary_server
{{ Fill tertiary_server Description }}

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

### -tertiary_secret
{{ Fill tertiary_secret Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeout
{{ Fill timeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -nas_ip
{{ Fill nas_ip Description }}

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

### -auth_type
{{ Fill auth_type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -nas_id
{{ Fill nas_id Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
Position: 12
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
Position: 13
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
Position: 14
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
