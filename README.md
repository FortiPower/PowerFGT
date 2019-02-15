

# PowerFGT

This is a Powershell module for configure a FortiGate (Fortinet) Firewall.

With this module (version 0.1.0) you can manage:

- Address (Get/Add/Remove object type ipmask/subnet) 

More functionality will be added later.

Connection can use HTTPS (default) or HTTP
Tested with FortiGate (using 5.6.x and 6.0.x firmware)

# Usage

All resource management functions are available with the Powershell verbs GET, ADD, SET, REMOVE. 
For example, you can manage Address with the following commands:
- `Get-FGTAddress`
- `Add-FGTAddresss`
- `Remove-FGTAddresss`

# Requirements

- Powershell 5 (If possible get the latest version)
- An Fortinet FortiGate Firewall and HTTPS enable (recommended)

# Instructions
### Install the module
```powershell
# Automated installation (Powershell 5):
    Install-Module PowerFGT

# Import the module
    Import-Module PowerFGT

# Get commands in the module
    Get-Command -Module PowerFGT

# Get help
    Get-Help Get-FGTAddress -Full
```

# Examples
### Connecting to the FortiGate Firewall

The first thing to do is to connect to a FortiGate Firewall with the command `Connect-FGT` :

```powershell
# Connect to the FortiGate Firewall
    Connect-FGT 192.0.2.1

#we get a prompt for credential
```
if you get a warning about `Unable to connect` Look [Issue](#Issue)


### Address Management

You can create a new Address `Add-FGTAddress`, retrieve its information `Get-FGTAddress`, or delete it `Remove-FGTAddress`.

```powershell
# Create an address 
    Add-FGTAddress -type ipmask -Name 'My PowerFGT Network' -ip 192.0.2.1 -subnet 255.255.255.0!

    {Get-FGTAddress back}


# Get information about adresss
    Get-FGTAddress | ft

   {Get-FGTADdress back}


# Remove a address
    Remove-FGTAddress -name 'My PowerFGT Network'
```


### Disconnecting

```powershell
# Disconnect from the FortiGate
    Disconnect-FGT
```

# Issue

## Unable to connect
if you use `Connect-FGT` and get `Unable to Connect (certificate)`

The issue coming from use Self-Signed or Expired Certificate for Firewall Management
Try to connect using `Connect-FGT -SkipCertificateCheck`

You can use also `Connect-FGT -httpOnly` for connect using HTTP (NOT RECOMMANDED !)

# List of available command
```powershell
Get-FGT...
```

# Author

**Alexis La Goutte**
- <https://github.com/alagoutte>
- <https://twitter.com/alagoutte>

**Benjamin Perrier**
- <https://github.com/benper44>

# Special Thanks

- Warren F. for his [blog post](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/) 'Building a Powershell module'
- Erwan Quelin for help about Powershell

# License

Copyright 2019 Alexis La Goutte and the community.
