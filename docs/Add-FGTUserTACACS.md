---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTUserTACACS

## SYNOPSIS
Add a FortiGate TACACS+ Server

## SYNTAX

```
Add-FGTUserTACACS [-name] <String> [-server] <String> [-key] <SecureString> [[-secondary_server] <String>]
 [[-secondary_key] <SecureString>] [[-tertiary_server] <String>] [[-tertiary_key] <SecureString>]
 [[-port] <Int32>] [[-authen_type] <String>] [-authorization] [[-visibility] <Boolean>] [[-data] <Hashtable>]
 [[-vdom] <String[]>] [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate TACACS+ Server

## EXAMPLES

### EXAMPLE 1
```
$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey
```

Add a TACACS+ Server with tacacs.powerfgt as server and key

### EXAMPLE 2
```
$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -secondary_server tacacs2.powerfgt -secondary_key $mykey -tertiary_server tacacs3.powerfgt -tertiary_key $mykey
```

Add a TACACS+ Server with tacacs.powerfgt as server and key, and secondary and tertiary servers

### EXAMPLE 3
```
$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -port 49
```

Add a TACACS+ Server with tacacs.powerfgt as server and key and port set to 49

### EXAMPLE 4
```
$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -authen_type chap
```

Add a TACACS+ Server with tacacs.powerfgt as server and key and CHAP as authentication type

### EXAMPLE 5
```
$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -authen_type auto
```

Add a TACACS+ Server with tacacs.powerfgt as server and key and PAP, MSCHAP and CHAP as authentication type in that order

### EXAMPLE 6
```
$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -authorization
```

Add a TACACS+ Server with tacacs.powerfgt as server and key and authorization enable

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

### -key
{{ Fill key Description }}

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

### -secondary_key
{{ Fill secondary_key Description }}

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

### -tertiary_key
{{ Fill tertiary_key Description }}

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

### -port
{{ Fill port Description }}

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

### -authen_type
{{ Fill authen_type Description }}

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

### -authorization
{{ Fill authorization Description }}

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

### -visibility
{{ Fill visibility Description }}

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
