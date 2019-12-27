

# PowerFGT

This is a Powershell module for configure a FortiGate (Fortinet) Firewall.

With this module (version 0.3.0) you can manage:

- [Address](#Address) (Add/Get/Copy/Set/Remove object type ipmask/subnet)
- [AddressGroup](#Address-Group) (Add/Get/Copy/Set/Remove and Add/Remove Member)
- DNS (Get)
- HA (Get)
- Interface (Get)
- IP Pool (Get)
- Local User (Get)
- [Policy](#Policy) (Add/Get/Remove)
- RoutePolicy (Get)
- Service (Get)
- Service Group (Get)
- Static Route (Get)
- System Global (Get)
- [VDOM](#VDOM) (Get)
- [Virtual IP](#Virtual-IP) (Get/Add/Remove object type static-nat)
- Virtual WAN Link/SD-WAN (Get)
- VPN IPsec Phase 1/Phase 2 Interface (Get)
- Zone (Get)

There is some extra feature
- [Invoke API](#Invoke-API)
- [Filtering](#Filtering)
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
- `Add-FGTFirewallAddress`
- `Copy-FGTFirewallAddress`
- `Set-FGTFirewallAddress`
- `Remove-FGTFirewallAddress`

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


### Address

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

# Get information some address (filter_type contains) and display only some field (using Format-Table)
    Get-FGTFirewallAddress -name update -filter_type contains | Select name, type, fqdn | Format-Table

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
    Get-FGTFirewallAddress -name myFGT
...

# Get NetworkDevice contains myFGT
    Get-FGTFirewallAddress -name myFGT -filter_type contains
...

# Get NetworkDevice where subnet equal 192.0.2.0 255.255.255.0
    Get-FGTFirewallAddress -filter_attribute subnet -filter_type equal -filter_value 192.0.2.0 255.255.255.0
...

```
Actually, support only `equal` and `contains` filter type

### Address Group

You can create a new Address Group `Add-FGTFirewallAddressGroup`, retrieve its information `Get-FGTFirewallAddressGroup`,
modify its properties `Set-FGTFirewallAddressGroup`, copy/clone its properties `Copt-FGTFirewallAddressGroup`,
Add member to Address Group `Add-FGTFirewallAddressGroup` and remove member `Add-FGTFirewallAddressGroup`,
or delete it `Remove-FGTFirewallAddressGroup`.  

```powershell

# Get information about ALL address Group (using Format Table)
    Get-FGTFirewallAddressgroup | Format-Table

    q_origin_key     name             uuid                                 member
    ------------     ----             ----                                 ------
    My Address Group My Address Group 292f6eaa-2613-51ea-866d-06cedca8805 {@{q_origin_key=FGT1; name=FGT1}, @{q_origin_ke…

# Add an address Group with FGT1 and FGT2 
    Add-FGTFirewallAddressGroup -name "My Address Group" -member FGT1, FGT2

    q_origin_key  : My Address Group
    name          : My Address Group
    uuid          : 292f6eaa-2613-51ea-866d-06cedca8805
    member        : {@{q_origin_key=FGT1; name=FGT1}, @{q_origin_key=FGT2; name=FGT2}}
    comment       :
    visibility    : enable
    color         : 0
    tagging       : {}
    allow-routing : disable

# Add FGT3 member to existing address Group
    Get-FGTFirewallAddressGroup -name "My Address Group" | Add-FGTFirewallAddressGroupMember -member FGT3

    q_origin_key  : MyAddressGroup
    name          : MyAddressGroup
    uuid          : 292f6eaa-2613-51ea-866d-06cedca8805a
    member        : {@{q_origin_key=FGT1; name=FGT1}, @{q_origin_key=FGT2; name=FGT2}, @{q_origin_key=FGT3; name=FGT3}}
    comment       :
    visibility    : enable
    color         : 0
    tagging       : {}
    allow-routing : disable

# Remove FGT2 member to existing address Group
    Get-FGTFirewallAddressGroup -name "My Address Group" | Remove-FGTFirewallAddressGroupMember -member FGT2

    q_origin_key  : My Address Group
    name          : My Address Group
    uuid          : 292f6eaa-2613-51ea-866d-06cedca8805a
    member        : {@{q_origin_key=FGT1; name=FGT1}, @{q_origin_key=FGT3; name=FGT3}}
    comment       :
    visibility    : enable
    color         : 0
    tagging       : {}
    allow-routing : disable

# Modify an address (comment, member...)
    Get-FGTFirewallAddressGroup -name "My Address Group" | Set-FGTFirewallAddressGroup -comment "My Address Group with only FGT2" -member FGT2

    q_origin_key  : My Address Group
    name          : My Address Group
    uuid          : 292f6eaa-2613-51ea-866d-06cedca8805a
    member        : {@{q_origin_key=FGT2; name=FGT2}}
    comment       : My Address Group with only FGT2
    visibility    : enable
    color         : 0
    tagging       : {}
    allow-routing : disable

# Copy/Clone an address Group
    Get-FGTFirewallAddressGroup -name "My Address Group" | Copy-FGTFirewallAddressGroup -name "My New Address Group"

    q_origin_key  : My New Address Group
    name          : My New Address Group
    uuid          : 9c2673a8-2614-51ea-9ab0-dfbd6f2c0475
    member        : {@{q_origin_key=FGT2; name=FGT2}}
    comment       : My Address Group with only FGT2
    visibility    : enable
    color         : 0
    tagging       : {}
    allow-routing : disable

# Remove an address Group
    Get-FGTFirewallAddressGroup -name "My Address Group" | Remove-FGTFirewallAddressGroup

    Remove address group on Fortigate
    Proceed with removal of Address Group My Address Group ?
    [Y] Yes  [N] No  [?] Help (default is "N"): y
```

### Virtual IP

You can create a new Address Group `Add-FGTFirewallVip`, retrieve its information `Get-FGTFirewallVip`,
or delete it `Remove-FGTFirewallVip`.

```powershell

# Get information about ALL Virtual IP (using Format Table)
    Get-FGTFirewallVip | Format-Table

    q_origin_key name        id uuid                                 comment type       dns-mapping-ttl ldb-method src-filter service
    ------------ ----        -- ----                                 ------- ----       --------------- ---------- ---------- -------
    myVIP1       myVIP1       0 3ccb44c6-2662-51ea-a469-3148c8eff287         static-nat               0 static     {}         {}
    myVIP3-8080  myVIP3-8080  0 73989828-2662-51ea-c969-4ad22d450075         static-nat               0 static     {}         {}

# Add a Virtual IP with Static NAT (192.2.0.1 => 198.51.100.1)
    Add-FGTFirewallVip -name myVIP1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1

    q_origin_key                     : myVIP1
    name                             : myVIP1
    id                               : 0
    uuid                             : 3ccb44c6-2662-51ea-a469-3148c8eff287
    comment                          :
    type                             : static-nat
    dns-mapping-ttl                  : 0
    ldb-method                       : static
    src-filter                       : {}
    service                          : {}
    extip                            : 192.2.0.1
    extaddr                          : {}
    mappedip                         : {@{q_origin_key=198.51.100.1; range=198.51.100.1}}
    [...]

# Add a Virtual IP with Static NAT and Port Forward (192.2.0.2:8080 => 198.51.100.2:80)
    Add-FGTFirewallVip -name myVIP2-8080to80 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.2 -portforward -extport 8080 -mappedport 80

    q_origin_key                     : myVIP2-8080to80
    name                             : myVIP2-8080to80
    id                               : 0
    uuid                             : 73989828-2662-51ea-c969-4ad22d450075
    comment                          :
    type                             : static-nat
    dns-mapping-ttl                  : 0
    ldb-method                       : static
    src-filter                       : {}
    service                          : {}
    extip                            : 192.2.0.2
    extaddr                          : {}
    mappedip                         : {@{q_origin_key=198.51.100.2; range=198.51.100.2}}
    mapped-addr                      :
    extintf                          : any
    arp-reply                        : enable
    server-type                      :
    persistence                      : none
    nat-source-vip                   : disable
    portforward                      : enable
    protocol                         : tcp
    extport                          : 8080
    mappedport                       : 80
    [...]

# Remove an address Group
    Get-FGTFirewallVip -name myVIP1 | Remove-FGTFirewallVip

    Remove VIP on Fortigate
    Proceed with removal of VIP myVIP1 ?
    [Y] Yes  [N] No  [?] Help (default is "N"): Y
```

### Policy

You can create a new Address Group `Add-FGTFirewallPolicy`, retrieve its information `Get-FGTFirewallPolicy`
or delete it `Remove-FGTFirewallPolicy`.

```powershell
# Get information about ALL Policies (using Format Table)
    Get-FGTFirewallPolicy | Format-Table
    q_origin_key policyid name         uuid                                 srcintf                             dstintf                             srcaddr
    ------------ -------- ----         ----                                 -------                             -------                             -------
            1        1 MyFGTPolicy  31a7ad9e-266e-51ea-1691-4906abad2e8b {@{q_origin_key=port1; name=port1}} {@{q_origin_key=port2; name=port2}} {@{q_origin_key=all; name=all}
            2        2 MyFGTPolicy2 3c8e5212-266e-51ea-2300-dc5fcb1a8e2a {@{q_origin_key=port1; name=port1}} {@{q_origin_key=port3; name=port3}} {@{q_origin_key=all; name=all}}

# Add Policy (MyFGTPolicy) allow ALL traffic between port1 to port2
    Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
    q_origin_key                : 1
    policyid                    : 1
    name                        : MyFGTPolicy
    uuid                        : 31a7ad9e-266e-51ea-1691-4906abad2e8b
    srcintf                     : {@{q_origin_key=port1; name=port1}}
    dstintf                     : {@{q_origin_key=port2; name=port2}}
    srcaddr                     : {@{q_origin_key=all; name=all}}
    dstaddr                     : {@{q_origin_key=all; name=all}}
    internet-service            : disable
    internet-service-id         : {}
    internet-service-custom     : {}
    internet-service-src        : disable
    internet-service-src-id     : {}
    internet-service-src-custom : {}
    rtp-nat                     : disable
    rtp-addr                    : {}
    learning-mode               : disable
    action                      : accept
    send-deny-packet            : disable
    firewall-session-dirty      : check-all
    status                      : enable
    schedule                    : always
    schedule-timeout            : disable
    service                     : {@{q_origin_key=ALL; name=ALL}}
    [...]

# Add Policy (MyFGTPolicy2) allow ALL traffic between port1 to port3 and enable NAT (but disable rule)
    Add-FGTFirewallPolicy -name MyFGTPolicy2 -srcintf port1 -dstintf port3 -srcaddr all -dstaddr all -nat -status:$false -skip
    q_origin_key              : 2
    policyid                  : 2
    name                      : MyFGTPolicy2
    uuid                      : dc941a9e-266e-51ea-2f5c-41da0d900d92
    srcintf                   : {@{q_origin_key=port1; name=port1}}
    dstintf                   : {@{q_origin_key=port3; name=port3}}
    srcaddr                   : {@{q_origin_key=all; name=all}}
    dstaddr                   : {@{q_origin_key=all; name=all}}
    internet-service          : disable
    internet-service-src      : disable
    rtp-nat                   : disable
    learning-mode             : disable
    action                    : accept
    status                    : disable
    schedule                  : always
    schedule-timeout          : disable
    [...]

# Remove a Policy
    Get-FGTFirewallPolicy -name MyFGTPolicy2 | Remove-FGTFirewallPolicy
    Remove Policy on Fortigate
    Proceed with removal of Policy MyFGTPolicy2 ?
    [Y] Yes  [N] No  [?] Help (default is "N"): y
```

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
Add-FGTFirewallAddressGroup
Add-FGTFirewallAddressGroupMember
Add-FGTFirewallPolicy
Add-FGTFirewallPolicyMember
Add-FGTFirewallVip
Confirm-FGTAddress
Confirm-FGTAddressGroup
Confirm-FGTFirewallPolicy
Confirm-FGTVip
Connect-FGT
Copy-FGTFirewallAddress
Copy-FGTFirewallAddressGroup
Deploy-FGTVm
Disconnect-FGT
Get-FGTFirewallAddress
Get-FGTFirewallAddressGroup
Get-FGTFirewallIPPool
Get-FGTFirewallPolicy
Get-FGTFirewallServiceCustom
Get-FGTFirewallServiceGroup
Get-FGTFirewallVip
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
Remove-FGTFirewallAddressGroup
Remove-FGTFirewallAddressGroupMember
Remove-FGTFirewallPolicy
Remove-FGTFirewallPolicyMember
Remove-FGTFirewallVip
Set-FGTCipherSSL
Set-FGTConnection
Set-FGTFirewallAddress
Set-FGTFirewallAddressGroup
Set-FGTUntrustedSSL
Show-FGTException
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
