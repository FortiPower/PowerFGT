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

```
Connect-FGT [-Server] <String> [-Username <String>] [-Password <SecureString>] [-Credentials <PSCredential>]
 [-httpOnly] [-SkipCertificateCheck] [-port <Int32>] [-Timeout <Int32>] [-vdom <String[]>]
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
```

Connect-FGT -Server 192.0.2.1 -credential $cred

Connect to a FortiGate with IP 192.0.2.1 and passing (Get-)credential

### EXAMPLE 6
```
$mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
```

Connect-FGT -Server 192.0.2.1 -Username manager -Password $mysecpassword

Connect to a FortiGate with IP 192.0.2.1 using Username and Password

### EXAMPLE 7
```
$fw1 = Connect-ArubaFGT -Server 192.0.2.1
```

Connect to an FortiGate with IP 192.0.2.1 and store connection info to $fw1 variable

### EXAMPLE 8
```
$fw2 = Connect-ArubaFGT -Server 192.0.2.1 -DefaultConnection:$false
```

Connect to an FortiGate with IP 192.0.2.1 and store connection info to $fw2 variable
and don't store connection on global ($DefaultFGTConnection) variable

### EXAMPLE 9
```
Connect-FGT -Server 192.0.2.1 -Timeout 15
```

Connect to a Fortigate with IP 192.0.2.1 and timeout the operation if it takes longer
than 15 seconds to form a connection.
The Default value "0" will cause the connection to never timeout.

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

## NOTES

## RELATED LINKS
