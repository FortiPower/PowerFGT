---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTUserLDAP

## SYNOPSIS
Add a FortiGate LDAP Server

## SYNTAX

```
Add-FGTUserLDAP [-name] <String> [-server] <String> [[-secondary_server] <String>]
 [[-tertiary_server] <String>] [[-cnid] <String>] [-dn] <String> [[-type] <String>] [[-username] <String>]
 [[-password] <SecureString>] [[-secure] <String>] [[-data] <Hashtable>] [[-vdom] <String[]>]
 [[-connection] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a FortiGate LDAP Server (Server, dc, cnid...)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt"
```

Add a LDAP Server named MyFGTUserLDAP using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt

### EXAMPLE 2
```
Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -cnid sAMAccountName
```

Add a LDAP Server named MyFGTUserLDAP using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt and sAMAccountName as CNID

### EXAMPLE 3
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS C:\>Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -type regular -username svc_powerfgt -password $mypassword
```

Add a LDAP Server named MyFGTUserLDAP using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt of type regular with specified username and password for binding

### EXAMPLE 4
```
Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -secure ldaps
```

Add a LDAP Server named MyFGTUserLDAP using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt, and secure connection (LDAPS)

### EXAMPLE 5
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -secondary_server ldap2.powerfgt -tertiary_server ldap3.powerfgt -cnid SAMAccountName -type simple -username svc_powerfgt -password $mypassword -secure ldaps
```

Add a LDAP Server named MyFGTUserLDAP using ldap.powerfgt as primary server, ldap2.powerfgt as secondary server and ldap3.powerfgt as tertiary server with Base DN dc=fgt,dc=power,dc=powerfgt, SAMAccountName as CNID, a regular account and secure connection (LDAPS)

### EXAMPLE 6
```
$data = @{ "port" = 10389 }
PS C:\>Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -data $data
```

Add a LDAP Server named MyFGTUserLDAP using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt and port 10389 via -data parameter

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

### -secondary_server
{{ Fill secondary_server Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -cnid
{{ Fill cnid Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dn
{{ Fill dn Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
{{ Fill type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -username
{{ Fill username Description }}

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

### -password
{{ Fill password Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secure
{{ Fill secure Description }}

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
