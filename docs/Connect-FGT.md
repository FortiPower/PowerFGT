---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Connect-FGT

## SYNOPSIS
Connect to a FortiGate

## SYNTAX

### default (Default)
```
Connect-FGT [-Server] <String> [-Username <String>] [-Password <SecureString>] [-ApiToken <String>]
 [-New_Password <SecureString>] [-Credentials <PSCredential>] [-httpOnly] [-SkipCertificateCheck]
 [-port <Int32>] [-Timeout <Int32>] [-token_code <String>] [-token_prompt] [-vdom <String[]>]
 [-DefaultConnection <Boolean>] [<CommonParameters>]
```

### token
```
Connect-FGT [-Server] <String> [-Username <String>] [-Password <SecureString>] [-ApiToken <String>]
 [-New_Password <SecureString>] [-Credentials <PSCredential>] [-httpOnly] [-SkipCertificateCheck]
 [-port <Int32>] [-Timeout <Int32>] [-token_code <String>] [-token_prompt] [-vdom <String[]>]
 [-DefaultConnection <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Connect to a FortiGate

## EXAMPLES

### EXAMPLE 1
```
Connect-FGT -Server 192.0.2.1
```

Connect to a FortiGate with IP 192.0.2.1

### EXAMPLE 2
```
Connect-FGT -Server 192.0.2.1 -SkipCertificateCheck
```

Connect to a FortiGate with IP 192.0.2.1 and disable Certificate (chain) check

### EXAMPLE 3
```
Connect-FGT -Server 192.0.2.1 -httpOnly
```

Connect to a FortiGate using HTTP (unsecure !) with IP 192.0.2.1 using (Get-)credential

### EXAMPLE 4
```
Connect-FGT -Server 192.0.2.1 -port 4443
```

Connect to a FortiGate using HTTPS (with port 4443) with IP 192.0.2.1 using (Get-)credential

### EXAMPLE 5
```
$cred = get-credential
Connect-FGT -Server 192.0.2.1 -credential $cred
```

Connect to a FortiGate with IP 192.0.2.1 and passing (Get-)credential

### EXAMPLE 6
```
$mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
Connect-FGT -Server 192.0.2.1 -Username manager -Password $mysecpassword
```

Connect to a FortiGate with IP 192.0.2.1 using Username and Password

### EXAMPLE 7
```
$fw1 = Connect-FGT -Server 192.0.2.1
Connect to a FortiGate with IP 192.0.2.1 and store connection info to $fw1 variable
```

### EXAMPLE 8
```
$fw2 = Connect-FGT -Server 192.0.2.1 -DefaultConnection:$false
```

Connect to a FortiGate with IP 192.0.2.1 and store connection info to $fw2 variable
and don't store connection on global ($DefaultFGTConnection) variable

### EXAMPLE 9
```
Connect-FGT -Server 192.0.2.1 -Timeout 15
```

Connect to a Fortigate with IP 192.0.2.1 and timeout the operation if it takes longer
than 15 seconds to form a connection.
The Default value "0" will cause the connection to never timeout.

### EXAMPLE 10
```
$apiToken = Get-Content fortigate_api_token.txt
Connect-FGT -Server -192.0.2.1 -ApiToken $apiToken
```

Connect to a FortiGate with IP 192.0.2.1 and passing api token

### EXAMPLE 11
```
$mynewpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
Connect-FGT -Server 192.0.2.1 -new_password $mysecpassword
```

Connect to a FortiGate with IP 192.0.2.1 and change the password

### EXAMPLE 12
```
$mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
Connect-FGT -Server 192.0.2.1 -Username admin -Password $mysecpassword -token_code XXXXX
```

Connect to a FortiGate with IP 192.0.2.1 using Username, Password and (Forti)token code XXXXXX

### EXAMPLE 13
```
Connect-FGT -Server 192.0.2.1 -token_prompt
```

Connect to a FortiGate with IP 192.0.2.1 and it will ask to get (Forti)Token code when connect

## PARAMETERS

### -Server
{{ Fill Server Description }}

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

### -Username
{{ Fill Username Description }}

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

### -Password
{{ Fill Password Description }}

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

### -ApiToken
{{ Fill ApiToken Description }}

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

### -New_Password
{{ Fill New_Password Description }}

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

### -Credentials
{{ Fill Credentials Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -httpOnly
{{ Fill httpOnly Description }}

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

### -SkipCertificateCheck
{{ Fill SkipCertificateCheck Description }}

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

### -port
{{ Fill port Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
{{ Fill Timeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -token_code
{{ Fill token_code Description }}

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

### -token_prompt
{{ Fill token_prompt Description }}

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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultConnection
{{ Fill DefaultConnection Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
## NOTES

## RELATED LINKS
