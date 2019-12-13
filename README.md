

# PowerFGT

This is a Powershell module for configure a FortiGate (Fortinet) Firewall.

With this module (version 0.3.0) you can manage:

- Address (Get/Add/Copy/Set/Remove object type ipmask/subnet)
- AddressGroup (Get)
- DNS (Get)
- HA (Get)
- Interface (Get)
- IP Pool (Get)
- Local User (Get)
- Policy (Get)
- RoutePolicy (Get)
- Service (Get)
- Service Group (Get)
- Static Route (Get)
- System Global (Get)
- VDOM (Get)
- Virtual IP (Get/Add/Remove object type static-nat)
- Virtual WAN Link/SD-WAN (Get)
- VPN IPsec Phase 1/Phase 2 Interface (Get)
- Zone (Get)
- [Multi Connection](#MultiConnection)

More functionality will be added later.

Connection can use HTTPS (default) or HTTP  
Tested with FortiGate (using 5.6.x and 6.0.x firmware but it will be also work with 5.4.x)  
Add (Experimental) support of [VDOM](#VDOM) is available using -vdom parameter for each cmdlet
Don't use support to connect using API Token from 5.6.x (and later)

# Usage

All resource management functions are available with the Powershell verbs GET, ADD, COPY, SET, REMOVE.  
For example, you can manage Address with the following commands:
- `Get-FGTFirewallAddress`
- `Add-FGTFirewallAddresss`
- `Copy-FGTFirewallAddresss`
- `Set-FGTFirewallAddresss`
- `Remove-FGTFirewallAddresss`

# Requirements

- Powershell 5 or 6 (Core) (If possible get the latest version)
- An Fortinet FortiGate Firewall and HTTPS enable (recommended)

# Instructions
### Install the module
```powershell
# Automated installation (Powershell 5 or later):
    Install-Module PowerFGT

# Import the module
    Import-Module PowerFGT

# Get commands in the module
    Get-Command -Module PowerFGT

# Get help
    Get-Help Get-FGTFirewallAddress -Full
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

You can create a new Address `Add-FGTFirewallAddress`, retrieve its information `Get-FGTFirewallAddress`,
modify its properties `Set-FGTFirewallAddress`, copy/clone its properties `Copt-FGTFirewallAddress`
or delete it `Remove-FGTFirewallAddress`.

```powershell

# Get information about ALL address (using Format Table)
    Get-FGTFirewallAddress | Format-Table

    q_origin_key                 name                         uuid                                 subnet
    ------------                 ----                         ----                                 ------
    FIREWALL_AUTH_PORTAL_ADDRESS FIREWALL_AUTH_PORTAL_ADDRESS a940cdea-368c-51e9-2596-5ddfd54a087a 0.0.0.0 0.0.0.0
    SSLVPN_TUNNEL_ADDR1          SSLVPN_TUNNEL_ADDR1          a9416aca-368c-51e9-fe74-7dbb95fa64c9 10.212.134.200 10.212...
    all                          all                          a940cc32-368c-51e9-82f5-fa5337e9f45c 0.0.0.0 0.0.0.0
    autoupdate.opera.com         autoupdate.opera.com         a918c192-368c-51e9-ca8d-88cc94ed2d54 0.0.0.0 0.0.0.0
    google-play                  google-play                  a918cd22-368c-51e9-2f4f-2d914955741a 0.0.0.0 0.0.0.0
    swscan.apple.com             swscan.apple.com             a918d1dc-368c-51e9-08a7-c6004bf38fb9 0.0.0.0 0.0.0.0
    update.microsoft.com         update.microsoft.com         a918d650-368c-51e9-0cca-5f006a059f0b 0.0.0.0 0.0.0.0

# Create an address
    Add-FGTFirewallAddress -type ipmask -Name 'My PowerFGT Network' -ip 192.0.2.1 -mask 255.255.255.0

    q_origin_key         : My PowerFGT Network
    name                 : My PowerFGT Network
    uuid                 : 9c65f75e-383e-51e9-a33a-caeffb7cfd33
    subnet               : 192.0.2.0 255.255.255.0
    type                 : ipmask
    start-ip             : 192.0.2.0
    end-ip               : 255.255.255.0
    fqdn                 :
    country              :
    wildcard-fqdn        :
    cache-ttl            : 0
    wildcard             : 192.0.2.0 255.255.255.0
    sdn                  :
    tenant               :
    organization         :
    epg-name             :
    subnet-name          :
    sdn-tag              :
    policy-group         :
    comment              :
    visibility           : enable
    associated-interface :
    color                : 0
    filter               :
    obj-id               :
    list                 : {}
    tagging              : {}
    allow-routing        : disable


# Get information an address (name) and display only some field (using Format-Table)
    Get-FGTFirewallAddress -name "My PowerFGT Network" | Select name, subnet, type, start-ip, end-ip | Format-Table

    name                subnet                  type   start-ip  end-ip
    ----                ------                  ----   --------  ------
    My PowerFGT Network 192.0.2.0 255.255.255.0 ipmask 192.0.2.0 255.255.255.0

# Get information some address (match) and display only some field (using Format-Table
    Get-FGTFirewallAddress -match update | Select name, type, fqdn | Format-Table

    name                 type fqdn
    ----                 ---- ----
    autoupdate.opera.com fqdn autoupdate.opera.com
    update.microsoft.com fqdn update.microsoft.com

# Modify an address (name, comment, interface...)
    Get-FGTFirewallAddress -name "My PowerFGT Network" | Set-FGTFirewallAddress -name "MyNetwork" -comment "My comment" -interface port2

    q_origin_key         : MyNetwork
    name                 : MyNetwork
    uuid                 : 9c65f75e-383e-51e9-a33a-caeffb7cfd33
    subnet               : 192.0.2.0 255.255.255.0
    type                 : ipmask
    start-ip             : 192.0.2.0
    end-ip               : 255.255.255.0
    fqdn                 :
    country              :
    wildcard-fqdn        :
    cache-ttl            : 0
    wildcard             : 192.0.2.0 255.255.255.0
    sdn                  :
    tenant               :
    organization         :
    epg-name             :
    subnet-name          :
    sdn-tag              :
    policy-group         :
    comment              : My comment
    visibility           : enable
    associated-interface : port2
    color                : 0
    filter               :
    obj-id               :
    list                 : {}
    tagging              : {}
    allow-routing        : disable

# Copy/Clone an address
    Get-FGTFirewallAddress -name "MyNetwork" | Copy-FGTFirewallAddress -name "My New Network"

    q_origin_key         : My New Network
    name                 : My New Network
    uuid                 : 0c8da508-3840-51e9-f525-0601066767cc
    subnet               : 192.0.2.0 255.255.255.0
    type                 : ipmask
    start-ip             : 192.0.2.0
    end-ip               : 255.255.255.0
    fqdn                 :
    country              :
    wildcard-fqdn        :
    cache-ttl            : 0
    wildcard             : 192.0.2.0 255.255.255.0
    sdn                  :
    tenant               :
    organization         :
    epg-name             :
    subnet-name          :
    sdn-tag              :
    policy-group         :
    comment              : My comment
    visibility           : enable
    associated-interface : port2
    color                : 0
    filter               :
    obj-id               :
    list                 : {}
    tagging              : {}
    allow-routing        : disable

# Remove an address
    Get-FGTFirewallAddress -name "My Network" | Remove-FGTFirewallAddress
```

### Filtering

For `Invoke-FGTRestMethod`, it is possible to use -filter parameter
You need to use FortiGate API syntax :

| Key | Operator | Pattern | Full Request | Description
| ---------- | ------------------- | ------------------- | ------------------- | -------------------
| schedule | == | always | GET /api/v2/cmdb/firewall/policy/?filter=schedule==always | Only return firewall policy with schedule 'always'
| schedule | != | always | GET /api/v2/cmdb/firewall/policy/?filter=schedule!=always | Return all firewall policy with schedule other than 'always'


and Filter Operators :

|  Operator |  Description
| ---------- | -------------------
| == | Case insensitive match with pattern.
| != | Does not match with pattern (case insensitive).
| =@ | Pattern found in object value (case insensitive).
| !@ | Pattern not found in object value (case insensitive).
| <= | Value must be less than or equal to pattern.
| < | Value must be less than pattern.
| >= | Value must be greater than or equal to pattern.
| > | Value must be greater than pattern.

For  `Invoke-FGTRestMethod` and `Get-XXX` cmdlet like `Get-FGTFirewallAddress`, it is possible to using some helper filter (`-filter_attribute`, `-filter_type`, `-filter_value`)

```powershell
# Get NetworkDevice named myFGT
    Get-FGTFirewallAddress -name  myFGT
...

# Get NetworkDevice contains myFGT
    Get-FGTFirewallAddress -name myFGT -filter_type contains
...

# Get NetworkDevice where subnet equal 192.0.2.0 255.255.255.0
    Get-FGTFirewallAddress -filter_attribute subnet -filter_type equal -filter_value 192.0.2.0 255.255.255.0
...

```
Actually, support only `equal` and `contains` filter type


### Invoke API
for example to get Fortigate System Global Info

```powershell
# get FortiGate System Global using API
    (Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/system/global").results

    language                                : english
    gui-ipv6                                : disable
    gui-certificates                        : enable
    gui-custom-language                     : disable
    gui-wireless-opensecurity               : disable
    gui-display-hostname                    : disable
    gui-lines-per-page                      : 50
    admin-https-ssl-versions                : tlsv1-1 tlsv1-2
    admintimeout                            : 120
    admin-console-timeout                   : 0
    admin-concurrent                        : enable
    admin-lockout-threshold                 : 3
    admin-lockout-duration                  : 60
    refresh                                 : 0
    interval                                : 5
    failtime                                : 5
    daily-restart                           : disable
    restart-time                            : 00:00
    radius-port                             : 1812
    admin-login-max                         : 100
    remoteauthtimeout                       : 5
    ldapconntimeout                         : 500
    batch-cmdb                              : enable
    multi-factor-authentication             : optional
    dst                                     : enable
    timezone                                : 04
    traffic-priority                        : tos
    traffic-priority-level                  : medium
    anti-replay                             : strict
    send-pmtu-icmp                          : enable
    honor-df                                : enable
    revision-image-auto-backup              : disable
    revision-backup-on-logout               : disable
    management-vdom                         : root
    hostname                                : PowerFGT-FW1
[...]
```
to get API uri, you can use `api/v2/cmdb/?action=schema` uri for get `schema`  
You can look also `FortiOS - REST API Reference` available on [Fortinet Developer Network (FNDN)](https://fndn.fortinet.net/)

### VDOM

it is possible use VDOM using -vdom parameter on cmdlet command (by default it is root vdom)

For get FGT Firewall Address of vdomX
```powershell
    Get-FGTFirewallAddress -vdom vdomX
[...]
```

For get FGT Firewall Address of vdomX and root
```powershell
    Get-FGTFirewallAddress -vdom vdomX,root
[...]
```

For get FGT Firewall Address of all vdom
```powershell
    Get-FGTFirewallAddress -vdom *
[...]
```

You can configure the "default" vdom when connect using
```powershell
    Connect-FGT 192.0.2.1 -vdom vdomX
[...]
```

You can also change default vdom using
```powershell
    Set-FGTConnection -vdom vdomY
[...]
```

# MultiConnection

From release 0.3.0, it is possible to connect on same times to multi FortiGate
You need to use -connection parameter to cmdlet

For example to get interface of 2 FortiGate

```powershell
# Connect to first FortiGate
    $fw1 = Connect-FGT 192.0.2.1 -SkipCertificateCheck -DefaultConnection:$false

#DefaultConnection set to false is not mandatory but only don't set the connection info on global variable

# Connect to second FortiGate
    $sw2 = Connect-FGT 192.0.2.1 -SkipCertificateCheck -DefaultConnection:$false

# Get Interface for first FortiGate
    Get-FGTSystemInterface -connection $sw1 | Format-Table

    q_origin_key  name          vdom vrf cli-conn-status fortilink mode   distance priority dhcp-relay-service
    ------------  ----          ---- --- --------------- --------- ----   -------- -------- ------------------
    DCFW          DCFW          root   0               0 disable   static        5        0 enable
    FITNUC        FITNUC        root   0               0 disable   static        5        0 disable
....

# Get Interface for second FortiGate
    Get-FGTSystemInterface -connection $sw1 | Format-Table

    q_origin_key  name          vdom vrf cli-conn-status fortilink mode   distance priority dhcp-relay-service
    ------------  ----          ---- --- --------------- --------- ----   -------- -------- ------------------
    FSA-DMZ       FSA-DMZ       root   0               0 disable   static        5        0 disable
    FSA-DMZ2      FSA-DMZ2      root   0               0 disable   static        5        0 disable
    FWLC          FWLC          root   0               0 disable   static        5        0 enable
...

#Each cmdlet can use -connection parameter

```

### Disconnecting

```powershell
# Disconnect from the FortiGate
    Disconnect-FGT
```

# Issue

## Unable to connect (certificate)

if you use `Connect-FGT` and get `Unable to Connect (certificate)`

The issue coming from use Self-Signed or Expired Certificate for Firewall Management  
Try to connect using `Connect-FGT -SkipCertificateCheck`

## Unable to connect

You can use also `Connect-FGT -httpOnly` for connect using HTTP (NOT RECOMMENDED !)

# List of available command
```powershell
Add-FGTFirewallAddress
Add-FGTFirewallVip
Connect-FGT
Copy-FGTFirewallAddress
Disconnect-FGT
Get-FGTFirewallAddress
Get-FGTFirewallAddressgroup
Get-FGTFirewallIPPool
Get-FGTFirewallPolicy
Get-FGTFirewallServiceCustom
Get-FGTFirewallServiceGroup
Get-FGTFirewalVip
Get-FGTRouterPolicy
Get-FGTRouterStatic
Get-FGTSystemDns
Get-FGTSystemGlobal
Get-FGTSystemHA
Get-FGTSystemInterface
Get-FGTSystemVdom
Get-FGTSystemVirtualWANLink
Get-FGTSystemZone
Get-FGTUserLocal
Get-FGTVpnIpsecPhase1Interface
Get-FGTVpnIpsecPhase2Interface
Invoke-FGTRestMethod
Remove-FGTFirewallAddress
Remove-FGTFirewallVip
Set-FGTCipherSSL
Set-FGTFirewallAddress
Set-FGTUntrustedSSL
Show-FGTException
Confirm-FGTAddress
Confirm-FGTVip
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
