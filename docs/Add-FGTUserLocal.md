---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTUserLocal

## SYNOPSIS
Add a FortiGate Local User

## SYNTAX

```
Add-FGTUserLocal -name <String> [-status] [-passwd <SecureString>] [-two_factor <String>]
 [-two_factor_notification <String>] [-fortitoken <String>] [-email_to <String>] [-sms_phone <String>]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate Local User (Name, Password, MFA)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTUserLocal -Name FGT -passwd MyFGT -status
```

Add Local User object name FGT, password MyFGT and enable it

### EXAMPLE 2
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
Add-FGTUserLocal -Name FGT -passwd $mypassword -status -two_factor email -email_to powerfgt@fgt.power
```

Add Local User object name FGT, password mypassword and enable it, with two factor authentication by email

### EXAMPLE 3
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
Add-FGTUserLocal -Name FGT -passwd $mypassword -status -two_factor fortitoken -fortitoken XXXXXXXXXXXXXXXX -email_to powerfgt@fgt.power
```

Add Local User object name FGT, password mypassword and enable it, with two factor authentication by fortitoken

### EXAMPLE 4
```
$data = @{ "sms-phone" = "XXXXXXXXXX" }
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS C:\>Add-FGTUserLocal -Name FGT -passwd $mypassword -status -two_factor sms -data $data -email_to powerfgt@fgt.power
Add Add Local User object name FGT, password mypassword and enable it, with email and two factor via SMS and SMS Phone via -data parameter
```

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

### -passwd
{{ Fill passwd Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -two_factor
\[Parameter (Mandatory = $false, ParameterSetName = "radius")\]
        \[string\]$radius_server,
        \[Parameter (Mandatory = $false, ParameterSetName = "tacacs")\]
        \[string\]$tacacs_server,

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

### -two_factor_notification
{{ Fill two_factor_notification Description }}

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

### -fortitoken
{{ Fill fortitoken Description }}

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

### -email_to
{{ Fill email_to Description }}

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

### -sms_phone
{{ Fill sms_phone Description }}

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
