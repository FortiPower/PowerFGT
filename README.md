

# PowerFGT

<p align="center">
    <a href="https://www.powershellgallery.com/packages/PowerFGT/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/PowerFGT.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/PowerFGT/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/PowerFGT.svg" /></a>
    <!--
    <a href="https://www.powershellgallery.com/packages/PowerFGT/" alt="PS Platform">
        <img src="https://img.shields.io/powershellgallery/p/PowerFGT.svg" /></a>
    -->
</p>
<p align="center">
    <a href="https://github.com/FortiPower/PowerFGT/graphs/commit-activity" alt="GitHub Last Commit">
        <img src="https://img.shields.io/github/last-commit/FortiPower/PowerFGT/master.svg" /></a>
    <a href="https://raw.githubusercontent.com/FortiPower/PowerFGT/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/FortiPower/PowerFGT.svg" /></a>
    <a href="https://github.com/FortiPower/PowerFGT/graphs/contributors" alt="GitHub Contributors">
        <img src="https://img.shields.io/github/contributors/FortiPower/PowerFGT.svg"/></a>
</p>

This is a Powershell module for configure a FortiGate (Fortinet) Firewall.

With this module (version 0.9.1) you can manage:

- [Address](#address) (Add/Get/Copy/Set/Remove object type ipmask/subnet, FQDN, iprange, geo, mac and dynamic (SDN))
- [AddressGroup](#address-group) (Add/Get/Copy/Set/Remove and Add/Remove Member)
- DHCPServer (Get)
- DNS (Get)
- HA (Get)
- [Interface](#interface) (Add/Get/Set/Remove Vlan, aggregate, loopback and Add/Remove Member)
- IP Pool (Get)
- [Log Traffic/Event](#log) (Get)
- [Monitor](#monitor) (Get)
- [Policy](#policy) (Add/Get/Remove)
- [Proxy Address/Address Group/ Policy](#proxy) (Add/Get/Set/Remove)
- [Local In Policy](#local-in-poloicy) (Add/Get/Copy/Set/Remove and Add/Remove Member)
- [Router BGP](#bgp) (Get/Set)
- [Router OSPF](#ospf) (Get/Set)
- RoutePolicy (Get)
- [SDN Connector](#sdn-connector) (Get)
- [Service Custom](#service-custom) (Add/Get/Set/Remove)
- [Service Group](#service-group) (Add/Get/Copy/Set/Remove and Add/Remove Member)
- [Static Route](#static-route) (Add/Get/Remove)
- [Switch(-controller)](#switch) (Get)
- [System Admin](#system-admin) (Add/Get/Set/Remove)
- [System Global](#settings) (Get/Set)
- [System Settings](#settings) (Get/Set)
- [Security Profiles](#security-profiles) (Get)
- [User LDAP](#user-ldap) (Add/Get/Set/Remove)
- [User Local](#user-local) (Add/Get/Set/Remove)
- [User Group](#user-group) (Add/Get/Copy/Set/Remove and Add/Remove Member)
- User SAML (Get)
- [User RADIUS](#user-radius) (Add/Get/Set/Remove)
- [User TACACS](#user-tacacs) (Add/Get/Set/Remove)
- [VDOM](#vdom) (Get)
- [Virtual IP](#virtual-ip) (Add/Get/Remove object type static-nat)
- [Virtual IP Group](#virtual-ip-group) (Add/Get/Copy/Set/Remove and Add/Remove Member)
- Virtual WAN Link/SD-WAN (Get)
- [VPN IPsec](#vpn-ipsec) [Phase 1](#vpn-ipsec-interface-phase-1)/[Phase 2](#vpn-ipsec-interface-phase-2) Interface (Add/Get/Set/Remove)
- VPN SSL (Get Client, Portal, Settings)
- Web Filter (Get Profile)
- [Wireless](#wireless) (Get)
- [Zone](#zone) (Add/Get/Set/Remove and Add/Remove Member)
- [ZTNA](#ztna) (Get Access Proxy)

There is some extra feature
- [Invoke API](#invoke-api)
- [Filtering](#filtering)
- [Multi Connection](#multiconnection)

More functionality will be added later.

Connection can use HTTPS (default) or HTTP  
Tested with FortiGate (using 5.6.x, 6.x and 7.x firmware but it will be also work with 5.4.x)  
Add (Experimental) support of [VDOM](#vdom) is available using -vdom parameter for each cmdlet  

# Usage

All resource management functions are available with the Powershell verbs GET, ADD, COPY, SET, REMOVE.  
For example, you can manage Address with the following commands:
- `Get-FGTFirewallAddress`
- `Add-FGTFirewallAddress`
- `Copy-FGTFirewallAddress`
- `Set-FGTFirewallAddress`
- `Remove-FGTFirewallAddress`

# Requirements

- Powershell 5 or 6.x/7.x (Core) (If possible get the latest version)
- A Fortinet FortiGate Firewall and HTTPS enable (recommended)

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

You can select the port using `-port` parameter

```powershell
# Connect to the FortiGate Firewall using port 4443
    Connect-FGT 192.0.2.1 -port 4443
```

if you are using OTP (FortiToken) for admin access, you can use -token_code or -token_prompt for specifity or ask the token/OTP when connecting

```powershell
# Connect to the FortiGate Firewall with the token asked
    Connect-FGT 192.0.2.1 -token_prompt
```

You can also connect using API Token ([Documentation for Generate REST API ](https://docs.fortinet.com/document/fortigate/7.2.1/administration-guide/399023/rest-api-administrator))

```powershell
# Connect to the FortiGate Firewall with API Token
    Connect-FGT 192.0.2.1 -apitoken 79GyN89Q7w00rG6pj09yd7wGG3kmds
```

if you get a warning about `Unable to connect` Look [Issue](#issue)

### Address

You can create a new Address `Add-FGTFirewallAddress`, retrieve its information `Get-FGTFirewallAddress`,
modify its properties `Set-FGTFirewallAddress`, copy/clone its properties `Copy-FGTFirewallAddress`
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

# Create an address (type ipmask)
    Add-FGTFirewallAddress -Name 'My PowerFGT Network' -ip 192.0.2.1 -mask 255.255.255.0

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
    Get-FGTFirewallAddress -name "MyNetwork" | Remove-FGTFirewallAddress

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Firewall Address" on target "MyNetwork".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):Y

#You can also create other address type like fqdn, iprange or geography

# Create an address (type fqdn)
    Add-FGTFirewallAddress -Name FortiPower -fqdn fortipower.github.io

    name                 : FortiPower
    q_origin_key         : FortiPower
    uuid                 : 98af3292-3d6e-51eb-f488-f04057fbb871
    type                 : fqdn
    sub-type             : sdn
    clearpass-spt        : unknown
    start-mac            : 00:00:00:00:00:00
    end-mac              : 00:00:00:00:00:00
    fqdn                 : fortipower.github.io
    country              : 
    cache-ttl            : 0
    sdn                  : 
    fsso-group           : {}
    interface            : 
    comment              : 
    visibility           : enable
    associated-interface : 
    color                : 0
    filter               : 
    sdn-addr-type        : private
    obj-id               : 
    list                 : {}
    tagging              : {}
    allow-routing        : disable

# Create an address (type iprange)
   Add-FGTFirewallAddress -Name MyRange -startip 192.0.2.1 -endip 192.0.2.100

    name                 : MyRange
    q_origin_key         : MyRange
    uuid                 : a683a420-3d6e-51eb-5c90-f471f85943e8
    type                 : iprange
    sub-type             : sdn
    clearpass-spt        : unknown
    start-mac            : 00:00:00:00:00:00
    end-mac              : 00:00:00:00:00:00
    start-ip             : 192.0.2.1
    end-ip               : 192.0.2.100
    country              : 
    cache-ttl            : 0
    sdn                  : 
    fsso-group           : {}
    interface            : 
    comment              : 
    visibility           : enable
    associated-interface : 
    color                : 0
    filter               : 
    sdn-addr-type        : private
    obj-id               : 
    list                 : {}
    tagging              : {}
    allow-routing        : disable

# Create an address (type geography)
    Add-FGTFirewallAddress -name MyCountry -country FR

    name                 : MyCountry
    q_origin_key         : MyCountry
    uuid                 : 7cca6b06-f8ab-51ec-8db4-a82384435e50
    type                 : geography
    country              : FR
    cache-ttl            : 0
    sdn                  :
    comment              :
    visibility           : enable
    associated-interface :
    color                : 0
    filter               :
    obj-id               :
    list                 : {}
    tagging              : {}
    allow-routing        : disable

# Create an address (type mac)
    Add-FGTFirewallAddress -Name MyMAC -mac 01:02:03:04:05:06

    name                 : MyMAC
    q_origin_key         : MyMAC
    uuid                 : eabaa884-c42d-51ee-4a87-4605a5021da9
    type                 : mac
    sub-type             : sdn
    clearpass-spt        : unknown
    macaddr              : {@{macaddr=01:02:03:04:05:06; q_origin_key=01:02:03:04:05:06}}
    country              :
    cache-ttl            : 0
    sdn                  :
    fsso-group           : {}
    interface            :
    obj-type             : ip
    tag-detection-level  :
    tag-type             :
    dirty                : dirty
    comment              :
    associated-interface :
    color                : 0
    filter               :
    sdn-addr-type        : private
    node-ip-only         : disable
    obj-id               :
    list                 : {}
    tagging              : {}
    allow-routing        : disable
    fabric-object        : disable

# Create an address (type dynamic (SDN))
    Add-FGTFirewallAddress -name MySDN -sdn MySDNConnector -filter "VMNAME=MyVM"

    name                 : MySDN
    q_origin_key         : MySDN
    uuid                 : a656d5e4-d0ef-51ef-add8-8ec2d3dcb1f1
    type                 : dynamic
    sub-type             : sdn
    clearpass-spt        : unknown
    start-mac            : 00:00:00:00:00:00
    end-mac              : 00:00:00:00:00:00
    country              :
    cache-ttl            : 0
    sdn                  : MySDNConnector
    fsso-group           : {}
    interface            :
    obj-type             : ip
    comment              :
    associated-interface :
    color                : 0
    filter               : VMNAME=MyVM
    sdn-addr-type        : private
    obj-id               : q
    list                 : {}
    tagging              : {}
    allow-routing        : disable
    fabric-object        : disable

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
# Get Firewall Address named myFGT
    Get-FGTFirewallAddress -name myFGT
...

# Get Firewall Address contains myFGT
    Get-FGTFirewallAddress -name myFGT -filter_type contains
...

# Get Firewall Address where subnet equal 192.0.2.0 255.255.255.0
    Get-FGTFirewallAddress -filter_attribute subnet -filter_type equal -filter_value 192.0.2.0 255.255.255.0
...

```
Actually, support only `equal` and `contains` filter type

### Address Group

You can create a new Address Group `Add-FGTFirewallAddressGroup`, retrieve its information `Get-FGTFirewallAddressGroup`,
modify its properties `Set-FGTFirewallAddressGroup`, copy/clone its properties `Copy-FGTFirewallAddressGroup`,
Add member to Address Group `Add-FGTFirewallAddressGroupMember` and remove member `Remove-FGTFirewallAddressGroupMember`,
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

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Firewall Address Group" on target "My Address Group".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### Virtual IP

You can create a new Virtual IP `Add-FGTFirewallVip`, retrieve its information `Get-FGTFirewallVip`,
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

# Remove a Virtual IP
    Get-FGTFirewallVip -name myVIP1 | Remove-FGTFirewallVip

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Firewall VIP" on target "myVIP1".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### Virtual IP Group

You can create a new VIP Group `Add-FGTFirewallVIPGroup`, retrieve its information `Get-FGTFirewallVIPGroup`,
modify its properties `Set-FGTFirewallVIPGroup`, copy/clone its properties `Copy-FGTFirewallVIPGroup`,
Add member to Address Group `Add-FGTFirewallVIPGroupMember` and remove member `Remove-FGTFirewallVIPGroupMember`,
or delete it `Remove-FGTFirewallVIPGroup`.  

```powershell

# Get information about ALL VIP Group (using Format Table)
    Get-FGTFirewallVipGroup | Format-Table

    name       q_origin_key uuid                                 interface color comments member
    ----       ------------ ----                                 --------- ----- -------- ------
    MyVIPGroup MyVIPGroup   cb875532-3d82-51eb-f120-075c29c10657 any           0          {@{name=myVIP1; q_origin_key=myVIP1}, @{name=myVIP2; q_origin_key=myVIP2}}

# Add a VIP Group with myVIP1 and myVIP2
    Add-FGTFirewallVIPGroup -name "MyVIPGroup" -member myVIP1, myVIP2

    name         : MyVIPGroup
    q_origin_key : MyVIPGroup
    uuid         : cb875532-3d82-51eb-f120-075c29c10657
    interface    : any
    color        : 0
    comments     :
    member       : {@{name=myVIP1; q_origin_key=myVIP1}, @{name=myVIP2; q_origin_key=myVIP2}}

# Add myVIP3 member to existing Virtual IP GROUP
    Get-FGTFirewallVIPGroup -name "MyVIPGroup" | Add-FGTFirewallVIPGroupMember -member myVIP3

    name         : MyVIPGroup
    q_origin_key : MyVIPGroup
    uuid         : cb875532-3d82-51eb-f120-075c29c10657
    interface    : any
    color        : 0
    comments     :
    member       : {@{name=myVIP1; q_origin_key=myVIP1}, @{name=myVIP2; q_origin_key=myVIP2}, @{name=myVIP3; q_origin_key=myVIP3}}

# Remove myVIP2 member to existing Virtual IP Group
    Get-FGTFirewallVIPGroup -name "MyVIPGroup" | Remove-FGTFirewallVIPGroupMember -member myVIP2

    name         : MyVIPGroup
    q_origin_key : MyVIPGroup
    uuid         : cb875532-3d82-51eb-f120-075c29c10657
    interface    : any
    color        : 0
    comments     :
    member       : {@{name=myVIP1; q_origin_key=myVIP1}, @{name=myVIP3; q_origin_key=myVIP3}}

# Modify a Virtual IP Group
    Get-FGTFirewallVIPGroup -name "MyVIPGroup" | Set-FGTFirewallVIPGroup -comment "My Virtual IP with only myVIP2" -member myVIP2

    name         : MyVIPGroup
    q_origin_key : MyVIPGroup
    uuid         : cb875532-3d82-51eb-f120-075c29c10657
    interface    : any
    color        : 0
    comments     : My Virtual IP with only myVIP2
    member       : {@{name=myVIP2; q_origin_key=myVIP2}}

# Remove a Virtual IP Group
    Get-FGTFirewallVIPGroup -name "MyVIPGroup" | Remove-FGTFirewallVIPGroup

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Firewall VIP Group" on target "MyVIPGroup".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
```


### Policy

You can create a new Policy `Add-FGTFirewallPolicy`, retrieve its information `Get-FGTFirewallPolicy`
Add member to source or destinationn address `Add-FGTFirewallPolicyMember` and remove member `Add-FGTFirewallPolicyMember`,
set it `Set-FGTFirewallPolicy` or delete it `Remove-FGTFirewallPolicy`.

```powershell
# Get information about ALL Policies (using Format Table)
    Get-FGTFirewallPolicy | Format-Table
    q_origin_key policyid name         uuid                                 srcintf                             dstintf                             srcaddr
    ------------ -------- ----         ----                                 -------                             -------                             -------
            1           1 MyFGTPolicy  31a7ad9e-266e-51ea-1691-4906abad2e8b {@{q_origin_key=port1; name=port1}} {@{q_origin_key=port2; name=port2}} {@{q_origin_key=all; name=all}
            2           2 MyFGTPolicy2 3c8e5212-266e-51ea-2300-dc5fcb1a8e2a {@{q_origin_key=port1; name=port1}} {@{q_origin_key=port3; name=port3}} {@{q_origin_key=all; name=all}}

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
    uuid                      : 6ad55b33-e514-4d60-a661-6addfe7b3ac8
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

# Add FGT2 and FGT3 to source address (only FGT1 before)
    Get-FGTFirewallPolicy -name MyFGTPolicy3 | Add-FGTFirewallPolicyMember -srcaddr FGT1, FGT2

    q_origin_key              : 3
    policyid                  : 3
    name                      : MyFGTPolicy3
    uuid                      : d7d0fa66-3352-51ec-52cf-a215389b0ddb
    srcintf                   : {@{q_origin_key=port1; name=port1}}
    dstintf                   : {@{q_origin_key=port2; name=port2}}
    srcaddr                   : {@{q_origin_key=FGT1; name=FGT1}, @{q_origin_key=FGT2; name=FGT2}, @{q_origin_key=FGT3;name=FGT3}}
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

# Remove FGT3 from destination address (FGT1, FGT2, FGT3 before)
    Get-FGTFirewallPolicy -name MyFGTPolicy3 | Remove-FGTFirewallPolicyMember -srcaddr FGT3

    q_origin_key              : 3
    policyid                  : 3
    name                      : MyFGTPolicy3
    uuid                      : d7d0fa66-3352-51ec-52cf-a215389b0ddb
    srcintf                   : {@{q_origin_key=port1; name=port1}}
    dstintf                   : {@{q_origin_key=port2; name=port2}}
    srcaddr                   : {@{q_origin_key=all; name=all}}
    dstaddr                   : {@{q_origin_key=FGT1; name=FGT1}, @{q_origin_key=FGT2; name=FGT2}}
    internet-service          : disable
    internet-service-src      : disable
    rtp-nat                   : disable
    learning-mode             : disable
    action                    : accept
    status                    : disable
    schedule                  : always
    schedule-timeout          : disable
    [...]

# Move a Policy (MyFGTPolicy2 after MyFGTPolicy3)
    Get-FGTFirewallPolicy -name MyFGTPolicy2 | Move-FGTFirewallPolicy -after (Get-FGTFirewallPolicy -name MyFGTPolicy3)

    q_origin_key              : 2
    policyid                  : 2
    name                      : MyFGTPolicy2
    uuid                      : 6ad55b33-e514-4d60-a661-6addfe7b3ac8
    [...]


# Move a Policy (MyFGTPolicy3 before MyFGTPolicy2) with ask confirm
    Get-FGTFirewallPolicy -name MyFGTPolicy3 | Move-FGTFirewallPolicy -before (Get-FGTFirewallPolicy -name MyFGTPolicy2) -confirm

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Move Firewall Policy" on target "MyFGTPolicy3".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):

    q_origin_key              : 3
    policyid                  : 3
    name                      : MyFGTPolicy3
    uuid                      : d7d0fa66-3352-51ec-52cf-a215389b0ddb
    [...]


# Change a Policy Settings (Security Profiles with default profiles)
    Get-FGTFirewallPolicy -name MyFGTPolicy3 | Set-FGTFirewallPolicy -avprofile default -webfilterprofile default -dnsfilterprofile default -applicationlist default -ipssensor default

    q_origin_key              : 3
    policyid                  : 3
    name                      : MyFGTPolicy3
    uuid                      : d7d0fa66-3352-51ec-52cf-a215389b0ddb
    [...]
    av-profile                : default
    webfilter-profile         : default
    dnsfilter-profile         : default
    application-list          : default
    ips-sensor                : default

# Remove a Policy
    Get-FGTFirewallPolicy -name MyFGTPolicy2 | Remove-FGTFirewallPolicy
    Remove Policy on Fortigate
    Proceed with removal of Policy MyFGTPolicy2 ?
    [Y] Yes  [N] No  [?] Help (default is "N"): y
```

### Zone

You can create a new Zone `Add-FGTSystemZone`, retrieve its information `Get-FGTFSystemZone`,
modify its properties `Set-SystemZone`,
Add member to Zone `Add-SystemZoneMember` and remove member `Remove-SystemZoneMember`,
or delete it `Remove-SystemZone`.  

```powershell

# Get information about ALL Zone
    Get-FGTSystemZone

    name         : myPowerFGTZone
    q_origin_key : myPowerFGTZone
    tagging      : {}
    description  :
    intrazone    : deny
    interface    : {@{interface-name=port5; q_origin_key=port5}, @{interface-name=port6; q_origin_key=port6}}

# Add new Zone myPowerFGTZone2 with port7 and intrazone allowed
    Add-FGTSystemZone -name myPowerFGTZone2 -intrazone allow -interfaces port7

    name         : myPowerFGTZone2
    q_origin_key : myPowerFGTZone2
    tagging      : {}
    description  :
    intrazone    : allow
    interface    : {@{interface-name=port7; q_origin_key=port7}}

# Add new member (port8) to existing zone myPowerFGTZone2
    Get-FGTSystemZone -name myPowerFGTZone2 | Add-FGTSystemZoneMember -interfaces port8

    name         : myPowerFGTZone2
    q_origin_key : myPowerFGTZone2
    tagging      : {}
    description  :
    intrazone    : allow
    interface    : {@{interface-name=port7; q_origin_key=port7}, @{interface-name=port8; q_origin_key=port8}}

# Remove port7 member to existing zone myPowerFGTZone2
    Get-FGTSystemZone -name myPowerFGTZone2 | Remove-FGTSystemZoneMember -interfaces port7

    name         : myPowerFGTZone2
    q_origin_key : myPowerFGTZone2
    tagging      : {}
    description  :
    intrazone    : allow
    interface    : {@{interface-name=port8; q_origin_key=port8}}

# Modify a Zone (intrazone, interface...)
    Get-FGTSystemZone -name myPowerFGTZone2 | Set-FGTSystemZone -intrazone deny

    name         : myPowerFGTZone2
    q_origin_key : myPowerFGTZone2
    tagging      : {}
    description  :
    intrazone    : deny
    interface    : {@{interface-name=port8; q_origin_key=port8}}

# Remove a zone
    Get-FGTSystemZone -name myPowerFGTZone2 | Remove-FGTSystemZone

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove zone" on target "myPowerFGTZone2".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### Routing

#### Static Route

You can create a new Static Route `Add-FGTRouterStatic`, retrieve its information `Get-FGTRouterStatic`,
or delete it `Remove-FGTRouterStatic`.

```powershell
# Get information about ALL Static Route (using Format Table)
    Get-FGTRouterStatic | Format-Table
    seq-num q_origin_key status dst                        src             gateway        distance weight priority device
    ------- ------------ ------ ---                        ---             -------        -------- ------ -------- ------
          2            2 enable 192.0.2.0 255.255.255.0    0.0.0.0 0.0.0.0 198.51.100.254       10      0        0 port1
          3            3 enable 198.51.100.0 255.255.255.0 0.0.0.0 0.0.0.0 192.0.2.254          10      0        0 port2

# Add Static Route to 192.0.2.0/24 via 198.51.100.254 from port1
    Add-FGTRouterStatic -dst 192.0.2.0/24 -gateway 198.51.100.254 -device port1
    seq-num                 : 2
    q_origin_key            : 2
    status                  : enable
    dst                     : 192.0.2.0 255.255.255.0
    src                     : 0.0.0.0 0.0.0.0
    gateway                 : 198.51.100.254
    distance                : 10
    weight                  : 0
    priority                : 0
    device                  : port1
    comment                 :
    blackhole               : disable
    dynamic-gateway         : disable
    sdwan-zone              : {}
    dstaddr                 :
    internet-service        : 0
    internet-service-custom :
    link-monitor-exempt     : disable
    vrf                     : 0
    bfd                     : disable
    [...]

# Add Static Route to 198.51.100.0/24 via 192.0.2.254 from port2
    Add-FGTRouterStatic -dst 198.51.100.0/24 -gateway 192.0.2.254 -device port2
    seq-num                 : 3
    q_origin_key            : 3
    status                  : enable
    dst                     : 198.51.100.0 255.255.255.0
    src                     : 0.0.0.0 0.0.0.0
    gateway                 : 192.0.2.254
    distance                : 10
    weight                  : 0
    priority                : 0
    device                  : port2
    comment                 :
    blackhole               : disable
    dynamic-gateway         : disable
    sdwan-zone              : {}
    dstaddr                 :
    internet-service        : 0
    internet-service-custom :
    link-monitor-exempt     : disable
    vrf                     : 0
    bfd                     : disable
    [...]

# Remove a Static Route
    Get-FGTRouterStatic -filter_attribute seq-num -filter_type equal -filter_value 2 | Remove-FGTRouterStatic

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Router Static" on target "2".
    [Y] Yes  [N] No  [?] Help (default is "N"): y
```

#### BGP

You can retrieve BGP information `Get-FGTRouterBGP` or configure it `Set-FGTRouterBGP`.

```powershell
# Get information about Router BGP
    Get-FGTRouterBGP

    as                                 :
    router-id                          :
    keepalive-timer                    : 60
    holdtime-timer                     : 180
    always-compare-med                 : disable
    bestpath-as-path-ignore            : disable
    bestpath-cmp-confed-aspath         : disable
    bestpath-cmp-routerid              : disable
    bestpath-med-confed                : disable
    bestpath-med-missing-as-worst      : disable
    client-to-client-reflection        : enable
    dampening                          : disable
    deterministic-med                  : disable
    ebgp-multipath                     : enable
    ibgp-multipath                     : disable
    [...]

# Configure BGP (AS and router-id)
    Set-FGTRouterBGP -as 65001 -router_id 192.0.2.1

    as                                 : 65001
    router-id                          : 192.0.2.1
    [...]

# for configure BGP extra value, you need to use -data (for example holdtime and ebgp-multipath)
    $data = @{ "holdtime-timer" = 120 ; "ebgp-multipath" = "enable" }
    Set-FGTRouterBGP -data $data
    [...]
    holdtime-timer                     : 120
    [...]
    ebgp-multipath                     : enable
    [...]
```

#### OSPF

You can retrieve OSPF information `Get-FGTRouterOSPF` or configure it `Set-FGTRouterOSPF`.

```powershell
# Get information about Router OSPF
    Get-FGTRouterOSPF

    abr-type                          : standard
    auto-cost-ref-bandwidth           : 1000
    distance-external                 : 110
    distance-inter-area               : 110
    distance-intra-area               : 110
    database-overflow                 : disable
    database-overflow-max-lsas        : 10000
    database-overflow-time-to-recover : 300
    default-information-originate     : disable
    default-information-metric        : 10
    default-information-metric-type   : 2
    default-information-route-map     :
    default-metric                    : 10
    distance                          : 110
    rfc1583-compatible                : disable
    router-id                         : 0.0.0.0
    [...]

# Configure OSPF (Arouter-id)
    Set-FGTRouterOSPF -router_id 192.0.2.1

    [...]
    router-id                          : 192.0.2.1
    [...]

# for configure OSPF extra value, you need to use -data (for example b and bfd)
    $data = @{ "distance" = 150 ; "bfd" = "enable" }
    Set-FGTRouterOSPF -data $data
    [...]
    distance                          : 150
    [...]
    bfd                               : enable
    [...]
```

### Interface

You can create a new interface (Vlan ...) `Add-FGTSystemInterface`, retrieve its information `Get-FGTSystemInterface`,
modify its properties `Set-FGTSystemInterface` or delete it `Remove-FGTSystemInterface`.

```powershell

# Get information about ALL Interface (using Format Table)
    Get-FGTSystemInterface | Format-Table

    name      q_origin_key vdom vrf cli-conn-status fortilink switch-controller-source-ip mode   client-options distance
    ----      ------------ ---- --- --------------- --------- --------------------------- ----   -------------- --------
    fortilink fortilink    root   0               0 enable    outbound                    static {}                    5
    l2t.root  l2t.root     root   0               0 disable   outbound                    static {}                    5
    naf.root  naf.root     root   0               0 disable   outbound                    static {}                    5
    port1     port1        root   0               0 disable   outbound                    static {}                    5
    port2     port2        root   0               0 disable   outbound                    static {}                    5
    port3     port3        root   0               0 disable   outbound                    static {}                    5
    port4     port4        root   0               0 disable   outbound                    static {}                    5
    port5     port5        root   0               0 disable   outbound                    static {}                    5
    port6     port6        root   0               0 disable   outbound                    static {}                    5
    port7     port7        root   0               0 disable   outbound                    static {}                    5
    port8     port8        root   0               0 disable   outbound                    static {}                    5
    port9     port9        root   0               0 disable   outbound                    static {}                    5
    port10    port10       root   0               0 disable   outbound                    static {}                    5
    ssl.root  ssl.root     root   0               0 disable   outbound                    static {}                    5

# Create an interface (type vlan)
    Add-FGTSystemInterface -vlan_id 23 -interface port9 -name "PowerFGT_vlan23"

    name                                       : PowerFGT_vlan23
    q_origin_key                               : PowerFGT_vlan23
    vdom                                       : root
    vrf                                        : 0
    cli-conn-status                            : 0
    fortilink                                  : disable
    switch-controller-source-ip                : outbound
    mode                                       : static
    [...]

# Create an interface (type LACP)
    Add-FGTSystemInterface -name PowerFGT_lacp -atype lacp -member port9, port10

    name                                       : PowerFGT_lacp
    q_origin_key                               : PowerFGT_lacp
    vdom                                       : root
    vrf                                        : 0
    [...]
    type                                       : aggregate
    [...]
    member                                     : {@{interface-name=port9; q_origin_key=port9}, @{interface-name=port10; q_origin_key=port10}}
    lacp-mode                                  : active
    [...]

# Create an interface (type Loopback)
    Add-FGTSystemInterface -name PowerFGT_lo -loopback -mode static -ip 192.0.2.1 -netmask 255.255.255.255 -allowaccess ping

    name                                       : PowerFGT_lo
    q_origin_key                               : PowerFGT_lo
    vdom                                       : root
    [...]
    ip                                         : 192.0.2.1 255.255.255.255
    allowaccess                                : ping
    type                                       : loopback
    [...]

# Get information an Interface (name) and display only some field (using Format-Table)
    Get-FGTSystemInterface -name PowerFGT_vlan23 | select name, vlanid, ip

    name            vlanid ip
    ----            ------ --
    PowerFGT_vlan23     23 0.0.0.0 0.0.0.0

# Modify an interface (description, ip ...)
    Get-FGTSystemInterface -name PowerFGT_vlan23 | Set-FGTSystemInterface -alias ALIAS_PowerFGT -role lan -mode static -ip 192.0.2.1 -netmask 255.255.255.0 -allowaccess ping,https

    name                                       : PowerFGT_vlan23
    q_origin_key                               : PowerFGT_vlan23
    vdom                                       : root
    [...]
    ip                                         : 192.0.2.1 255.255.255.0
    allowaccess                                : ping https
    [...]
    interface                                  : port9
    external                                   : disable
    vlan-protocol                              : 8021q
    vlanid                                     : 23
    [...]
    description                                :
    alias                                      : ALIAS_PowerFGT
    [...]
    role                                       : lan
    [...]


# Add (append) allowaccess with SSH
    Get-FGTSystemInterface -name PowerFGT_vlan23 | Add-FGTSystemInterfaceMember -allowaccess ssh | select name, allowaccess

    name            allowaccess
    ----            -----------
    PowerFGT_vlan23 ping https ssh

# Remove allowaccess (https)
    Get-FGTSystemInterface -name PowerFGT_vlan23 | Remove-FGTSystemInterfaceMember -allowaccess https | select name, allowaccess

    name            allowaccess
    ----            -----------
    PowerFGT_vlan23 ping ssh

# Remove an interface
    Get-FGTSystemInterface -name PowerFGT_vlan23 | Remove-FGTSystemInterface

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove interface" on target "PowerFGT_vlan23".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### Security Profiles

You can change System Settings and System Global (settings) using `Set-FGTSystemSettings` and `Set-FGTSystemGlobal`

It is possible to Get Security Profiles (Antivirus, Application Control, DNS Filter, ISDB, SSL/SSH, IPS)

* `Get-FGTAntivirusProfile` List and Settings of Antivirus
* `Get-FGTApplicationList` List and Settings of Application (List)
* `Get-FGTDnsfilterProfile` List and Settings of DNS Filter Profile
* `Get-FGTFirewallInternetServiceName` List of Internet Service Name (ISDB)
* `Get-FGTFirewallSSLSSHProfile` List and Settings of SSL/SSH Profile
* `Get-FGTIpsSensor` List and Settings of IPS Sensor

### Settings

You can change System Settings and System Global (settings) using `Set-FGTSystemSettings` and `Set-FGTSystemGlobal`

```powershell

# Get ALL information about System Global
    Get-FGTSystemGlobal

    language                                 : english
    gui-ipv6                                 : disable
    gui-replacement-message-groups           : disable
    gui-local-out                            : disable
    gui-certificates                         : enable
    gui-custom-language                      : disable
    gui-wireless-opensecurity                : disable
    gui-display-hostname                     : disable
    gui-fortigate-cloud-sandbox              : disable
    gui-firmware-upgrade-warning             : enable
    gui-allow-default-hostname               : disable
    gui-forticare-registration-setup-warning : enable
    gui-cdn-usage                            : enable
    admin-https-ssl-versions                 : tlsv1-2
    [...]

# Get only admintimeout and admin-sport of System Global

    Get-FGTSystemGlobal -Name admintimeout, admin-sport

    admintimeout admin-sport
    ------------ -----------
            5         443

# Configure admintimeout and admin-sport of System Global

    Set-FGTSystemGlobal -admintimeout 30 -admin_sport 8443

    [...]
    admintimeout                             : 30
    [...]
    admin-sport                              : 8443
    [...]

# for configure a setting not yet available on parameter of Set-FGTSystemGlobal, you can use

    $data = @{ "two-factor-sms-expiry" = 120 }
    Set-FGTSystemGlobal -data $data

    [...]
    two-factor-sms-expiry                    : 120
    [...]

# Get ALL information about System Settings
    Get-FGTSystemSettings

    comments                           : 
    opmode                             : nat
    ngfw-mode                          : profile-based
    http-external-dest                 : fortiweb
    firewall-session-dirty             : check-all
    manageip                           :
    gateway                            : 0.0.0.0
    ip                                 : 0.0.0.0 0.0.0.0
    manageip6                          : ::/0
    gateway6                           : ::
    ip6                                : ::/0
    device                             :
    bfd                                : disable
    [...]

# Get only gui-allow-unnamed-policy and opmode of System Settings

    Get-FGTSystemSettings -Name gui-allow-unnamed-policy, opmode

    gui-allow-unnamed-policy opmode
    ------------------------ ------
    disable                  nat


# Configure gui-allow-unnamed-policy of System Settings

    Set-FGTSystemSettings -gui_allow_unnamed_policy

    [...]
    gui-allow-unnamed-policy           : enable
    [...]

# for configure a setting not yet available on parameter of Set-FGTSystemSettings, you can use

    $data = @{ "location-id" = "192.0.2.1" }
    Set-FGTSystemSettings -data $data

    [...]
    location-id                        : 192.0.2.1
    [...]

```

### System Admin

You can manage (System) Admin (Local) on FortiGate.

You can create a new (System) Admin `Add-FGTSystemAdmin`, retrieve its information `Get-FGTSystemAdmin`,
modify its properties `Set-FGTSystemAdmin` or delete it `Remove-FGTSystemAdmin`.

```powershell

# Create an Admin Local (using SecureString password) MyFGTAdmin with access profile super_admin

    $mypassword = ConvertTo-SecureString myadminpassword -AsPlainText -Force
    Add-FGTSystemAdmin -Name MyFGTAdmin -password $mypassword -accprofile super_admin

    name                                 : MyFGTAdmin
    q_origin_key                         : MyFGTAdmin
    wildcard                             : disable
    remote-auth                          : disable
    remote-group                         :
    password                             : ENC XXXX
    old-password                         : ENC XXXX
    peer-auth                            : disable
    peer-group                           :
    trusthost1                           : 0.0.0.0 0.0.0.0
    trusthost2                           : 0.0.0.0 0.0.0.0
    [...]

# Get information about ALL System Admin (using Format Table)
    Get-FGTSystemAdmin | Format-Table

    name       q_origin_key wildcard remote-auth remote-group password old-password peer-auth peer-group trusthost1
    ----       ------------ -------- ----------- ------------ -------- ------------ --------- ---------- ----------
    MyFGTAdmin MyFGTAdmin   disable  disable                  ENC XXXX ENC XXXX     disable              0.0.0.0 0.0.0.0
    admin      admin        disable  disable                  ENC XXXX ENC XXXX     disable              0.0.0.0 0.0.0.0

# Modify an System Admin (trusthost1...)
    Get-FGTSystemAdmin MyFGTAdmin| Set-FGTSystemAdmin -trusthost1 192.0.2.1/32

    name                                 : MyFGTAdmin
    q_origin_key                         : MyFGTAdmin
    wildcard                             : disable
    [...]
    trusthost1                           : 192.0.2.1 255.255.255.255
    [...]

# Remove an System Admin
    Get-FGTSystemAdmin MyFGTAdmin| Remove-FGTSystemAdmin

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove System Admin" on target "MyFGTAdmin".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### User

You can manage user (Local, LDAP, RADIUS, TACACS) on FortiGate and also manage user directory (LDAP, RADIUS, TACACS) and group.

#### User Local

You can create a new User Local `Add-FGTUserLocal`, retrieve its information `Get-FGTUserLocal`,
modify its properties `Set-FGTUserLocal` or delete it `Remove-FGTUserLocal`.

```powershell

# Create an User Local (using SecureString password) MyFGTUserLocal

    $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
    Add-FGTUserLocal -Name MyFGTUserLocal -passwd $mypassword

    name                      : MyFGTUserLocal
    q_origin_key              : MyFGTUserLocal
    id                        : 16779153
    status                    : enable
    type                      : password
    passwd                    : ENC XXXX
    ldap-server               :
    radius-server             :
    tacacs+-server            :
    two-factor                : disable
    two-factor-authentication :
    two-factor-notification   :
    fortitoken                :

    [...]

# Get information about ALL User Local (using Format Table)
    Get-FGTUserLocal | Format-Table

    name           q_origin_key         id status  type     passwd   ldap-server radius-server tacacs+-server two-factor
    ----           ------------         -- ------  ----     ------   ----------- ------------- -------------- ----------
    MyFGTUserLocal MyFGTUserLocal 16779153 enable  password ENC XXXX                                          disable
    guest          guest          16777217 enable  password ENC XXXX                                          disable

# Modify an User Local (status...)
    Get-FGTUserLocal -name MyFGTUserLocal | Set-FGTUserLocal -status:$false

    name                      : MyFGTUserLocal
    q_origin_key              : MyFGTUserLocal
    id                        : 16779153
    status                    : disable
    [...]

# Remove an User Local
    Get-FGTUserLocal -name MyFGTUserLocal | Remove-FGTUserLocal

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove User Local" on target "MyFGTUserLocal".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

#### User LDAP

You can create a new User LDAP `Add-FGTUserLDAP`, retrieve its information `Get-FGTUserLDAP`,
modify its properties `Set-FGTUserLDAP` or delete it `Remove-FGTUserLDAP`.

```powershell

# Create an User LDAP (using SecureString password) MyFGTUserLDAP

    $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
    Add-FGTUserLDAP -Name MyFGTUserLDAP -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -type regular -username svc_powerfgt -password $mypassword

    name                      : MyFGTUserLDAP
    q_origin_key              : MyFGTUserLDAP
    server                    : ldap.powerfgt
    secondary-server          :
    tertiary-server           :
    status-ttl                : 300
    server-identity-check     : enable
    source-ip                 :
    source-port               : 0
    cnid                      : cn
    dn                        : dc=fgt,dc=power,dc=powerfgt
    type                      : regular
    two-factor                : disable
    two-factor-authentication :
    two-factor-notification   :
    two-factor-filter         :
    username                  : svc_powerfgt
    password                  : ENC XXXX
    [...]

# Get information about ALL User LDAP (using Format Table)
    Get-FGTUserLDAP | Format-Table

    name          q_origin_key  server        secondary-server tertiary-server status-ttl server-identity-check source-ip source-port cnid
    ----          ------------  ------        ---------------- --------------- ---------- --------------------- --------- ----------- ----
    MyFGTUserLDAP MyFGTUserLDAP ldap.powerfgt                                         300 enable                                    0 cn

# Modify an User LDAP (server...)
    Get-FGTUserLDAP -name MyFGTUserLDAP | Set-FGTUserLDAP -server ldap2.powerfgt

    name                      : MyFGTUserLDAP
    q_origin_key              : MyFGTUserLDAP
    server                    : ldap2.powerfgt
    [...]

# Create an User Local using this User LDAP
    Add-FGTUserLocal -Name MyFGTUserLocalLDAP -ldap_server MyFGTUserLDAP

    name                      : MyFGTUserLocalLDAP
    q_origin_key              : MyFGTUserLocalLDAP
    id                        : 16779240
    status                    : enable
    type                      : ldap
    passwd                    :
    ldap-server               : MyFGTUserLDAP
    [...]

# Remove an User LDAP
    Get-FGTUserLDAP -name MyFGTUserLDAP | Remove-FGTUserLDAP

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove User Ldap" on target "MyFGTUserLDAP".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
```

#### User RADIUS

You can create a new User LDAP `Add-FGTUserRADIUS`, retrieve its information `Get-FGTUserRADIUS`,
modify its properties `Set-FGTUserRADIUS` or delete it `Remove-FGTUserRADIUS`.

```powershell

# Create an User RADIUS (using SecureString password) MyFGTUserRADIUS

    $secret = ConvertTo-SecureString mysecret -AsPlainText -Force
    Add-FGTUserRADIUS -Name MyFGTUserRADIUS -server radius.powerfgt -secret $mysecret

    name                                        : MyFGTUserRADIUS
    q_origin_key                                : MyFGTUserRADIUS
    server                                      : radius.powerfgt
    secret                                      : ENC XXXX
    secondary-server                            :
    secondary-secret                            :
    tertiary-server                             :
    tertiary-secret                             :
    timeout                                     : 5
    status-ttl                                  : 300
    all-usergroup                               : disable
    use-management-vdom                         : disable
    switch-controller-nas-ip-dynamic            : disable
    nas-ip                                      : 0.0.0.0
    [...]

# Get information about ALL User RADIUS (using Format Table)
    Get-FGTUserRADIUS | Format-Table

    name            q_origin_key    server          secret   secondary-server secondary-secret tertiary-server tertiary-secret timeout status-ttl
    ----            ------------    ------          ------   ---------------- ---------------- --------------- --------------- ------- ----------
    MyFGTUserRADIUS MyFGTUserRADIUS radius.powerfgt ENC XXXX                                                                         5        300

# Modify an User RADIUS (server...)
    Get-FGTUserRADIUS -name MyFGTUserRADIUS | Set-FGTUserRADIUS -server radius2.powerfgt

    name                      : MyFGTUserRADIUS
    q_origin_key              : MyFGTUserRADIUS
    server                    : radius2.powerfgt
    [...]

# Create an User Local using this User RADIUS
    Add-FGTUserLocal -Name MyFGTUserLocalRADIUS -radius_server MyFGTUserRADIUS

    name                      : MyFGTUserLocalRADIUS
    q_origin_key              : MyFGTUserLocalRADIUS
    id                        : 16779241
    status                    : enable
    type                      : radius
    passwd                    :
    ldap-server               :
    radius-server             : MyFGTUserRADIUS
    [...]

# Remove an User RADIUS
    Get-FGTUserRADIUS -name MyFGTUserRADIUS | Remove-FGTUserRADIUS

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove User Radius" on target "MyFGTUserRADIUS".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

#### User TACACS

You can create a new User LDAP `Add-FGTUserTACACS`, retrieve its information `Get-FGTUserTACACS`,
modify its properties `Set-FGTUserTACACS` or delete it `Remove-FGTUserTACACS`.

```powershell

# Create an User TACACS (using SecureString password) MyFGTUserTACACS

    $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
    Add-FGTUserTACACS -Name MyFGTUserTACACS -server tacacs.powerfgt -key $mykey

    name                    : MyFGTUserTACACS
    q_origin_key            : MyFGTUserTACACS
    server                  : tacacs.powerfgt
    secondary-server        :
    tertiary-server         :
    port                    : 49
    key                     : ENC XXXX
    secondary-key           :
    tertiary-key            :
    status-ttl              : 300
    [...]

# Get information about ALL User TACACS (using Format Table)
    Get-FGTUserTACACS | Format-Table

    name            q_origin_key    server          secondary-server tertiary-server port key      secondary-key tertiary-key status-ttl
    ----            ------------    ------          ---------------- --------------- ---- ---      ------------- ------------ ----------
    MyFGTUserTACACS MyFGTUserTACACS tacacs.powerfgt                                    49 ENC XXXX                                   300

# Modify an User TACACS (server...)
    Get-FGTUserTACACS -name MyFGTUserTACACS | Set-FGTUserTACACS -server tacacs2.powerfgt

    name                    : MyFGTUserTACACS
    q_origin_key            : MyFGTUserTACACS
    server                  : tacacs2.powerfgt
    [...]

# Create an User Local using this User TACACS
    Add-FGTUserLocal -Name MyFGTUserLocalTACACS -tacacs_server MyFGTUserTACACS

    name                      : MyFGTUserLocalTACACS
    q_origin_key              : MyFGTUserLocalTACACS
    id                        : 16779242
    status                    : enable
    type                      : tacacs+
    passwd                    :
    ldap-server               :
    radius-server             :
    tacacs+-server            : MyFGTUserTACACS
    [...]

# Remove an User TACACS
    Get-FGTUserTACACS -name MyFGTUserTACACS | Remove-FGTUserTACACS

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove User Tacacs" on target "MyFGTUserTACACS".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

#### User Group

You can create a new User Group `Add-FGTUserGroup`, retrieve its information `Get-FGTUserGroup`,
modify its properties `Set-FGTUserGroup`, copy/clone its properties `Copy-FGTUserGroup`,
Add member to Address Group `Add-FGTUserGroupMember` and remove member `Remove-FGTUserGroupMember`,
or delete it `Remove-FGTUserGroup`.  

```powershell

# Get information about ALL User Group (using Format Table)
    Get-FGTUserGroup | Format-Table

    name            q_origin_key          id group-type   authtimeout  member
    ----            ------------          -- ----------   -----------  ------
    Guest-group     Guest-group            1 firewall               0  {@{name=guest; q_origin_key=guest}}
    SSO_Guest_Users SSO_Guest_Users 16777215 fsso-service           0  {}

# Add an User Group with MyFGTUserLocal1 and MyFGTUserLocal2
    Add-FGTUserGroup -name "My User Group" -member MyFGTUserLocal1, MyFGTUserLocal2

    name                     : My User Group
    q_origin_key             : My User Group
    id                       : 848
    group-type               : firewall
    authtimeout              : 0
    auth-concurrent-override : disable
    auth-concurrent-value    : 0
    http-digest-realm        :
    sso-attribute-value      :
    member                   : {@{name=MyFGTUserLocal1; q_origin_key=MyFGTUserLocal1}, @{name=MyFGTUserLocal2; q_origin_key=MyFGTUserLocal2}}
    match                    : {}
    user-id                  : email
    [...]

# Add MyFGTUserLocal3 member to existing User Group
    Get-FGTUserGroup -name "My User Group" | Add-FGTUserGroupMember -member MyFGTUserLocal3

    name                     : My User Group
    q_origin_key             : My User Group
    id                       : 848
    group-type               : firewall
    authtimeout              : 0
    auth-concurrent-override : disable
    auth-concurrent-value    : 0
    http-digest-realm        :
    sso-attribute-value      :
    member                   : {@{name=MyFGTUserLocal1; q_origin_key=MyFGTUserLocal1}, @{name=MyFGTUserLocal2; q_origin_key=MyFGTUserLocal2}, @{name=MyFGTUserLocal3; 
                            q_origin_key=MyFGTUserLocal3}}
    [...]

# Remove MyFGTUserLocal2 member to existing User Group
    Get-FGTUserGroup -name "My User Group" | Remove-FGTUserGroupMember -member MyFGTUserLocal2

    name                     : My User Group
    q_origin_key             : My User Group
    id                       : 848
    group-type               : firewall
    authtimeout              : 0
    auth-concurrent-override : disable
    auth-concurrent-value    : 0
    http-digest-realm        :
    sso-attribute-value      :
    member                   : {@{name=MyFGTUserLocal1; q_origin_key=MyFGTUserLocal1}, @{name=MyFGTUserLocal3; q_origin_key=MyFGTUserLocal3}}
    [...]

# Modify an User Group (member...)
    Get-FGTUserGroup -name "My User Group" | Set-FGTUserGroup -member MyFGTUserLocal2

    name                     : My User Group
    q_origin_key             : My User Group
    id                       : 848
    group-type               : firewall
    authtimeout              : 0
    auth-concurrent-override : disable
    auth-concurrent-value    : 0
    http-digest-realm        :
    sso-attribute-value      :
    member                   : {@{name=MyFGTUserLocal2; q_origin_key=MyFGTUserLocal2}}
    [...]

# Copy/Clone an User Group
    Get-FGTUserGroup -name "My User Group" | Copy-FGTUserGroup -name "My New User Group"

    name                     : My New User Group
    q_origin_key             : My New User Group
    id                       : 849
    group-type               : firewall
    authtimeout              : 0
    auth-concurrent-override : disable
    auth-concurrent-value    : 0
    http-digest-realm        :
    sso-attribute-value      :
    member                   : {@{name=MyFGTUserLocal2; q_origin_key=MyFGTUserLocal2}}

# Remove an User Group
    Get-FGTUserGroup -name "My User Group" | Remove-FGTUserGroup

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove User Group" on target "My User Group".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### SDN Connector

You can create a new SDN Connector `Add-FGTSystemSDNConnector`,
retrieve its information `Get-FGTSystemSDNConnector`, modify its properties `Set-FGTSystemSDNConnector`
or delete it `Remove-FGTSystemSDNConnector`.

```powershell

# Create a new SDN Connector (only support type vmware for the moment)
    $mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
    Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword

    name             : MySDNConnector
    q_origin_key     : MySDNConnector
    status           : enable
    type             : vmware
    ha-status        : disable
    server           : MyVcenter
    server-port      : 0
    username         : powerfgt@vsphere.local
    password         : ENC -1TqQaNbQElm4Ft0QrzPkZgYCt6K0=
    [...]


# Get information about ALL SDN connector (using Format Table)
    Get-FGTSystemSDNConnector | Format-Table

    name           q_origin_key   status type   ha-status server    server-port username               password
    ----           ------------   ------ ----   --------- ------    ----------- --------               --------
    MySDNConnector MySDNConnector enable vmware disable   MyVcenter           0 powerfgt@vsphere.local ENC -1TqQa

# Modify a SDN connector (update-interval, status ...)
     Get-FGTSystemSDNConnector -name MySDNConnector| Set-FGTSystemSDNConnector -update_interval 120

    name             : MySDNConnector
    q_origin_key     : MySDNConnector
    status           : enable
    type             : vmware
    ha-status        : disable
    server           : MyVcenter
    server-port      : 0
    username         : powerfgt@vsphere.local
    password         : ENC -1TqQaNbQElm4Ft0QrzPkZgYCt6K0=
    [...]
    update-interval  : 120

# Remove a SDN Connector
    Get-FGTSystemSDNConnector -name MySDNConnector| Remove-FGTSystemSDNConnector

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove SDN Connector" on target "MySDNConnector".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
```

### Service

#### Service Custom

You can create a new Service Custom `Add-FGTFirewallServiceCustom`,
retrieve its information `Get-FGTFirewallServiceCustom`, modify its properties `Set-FGTFirewallServiceCustom`
or delete it `Remove-FGTFirewallServiceCustom`.

```powershell

# Create a new Service Custom (TCP 8080)
    Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8080 -tcp_port 8080

    name                : MyServiceCustomTCP8080
    q_origin_key        : MyServiceCustomTCP8080
    proxy               : disable
    category            :
    protocol            : TCP/UDP/SCTP
    helper              : auto
    iprange             : 0.0.0.0
    fqdn                :
    tcp-portrange       : 8080
    udp-portrange       :
    sctp-portrange      :
    [...]


# Get information about ALL Service Custom (using Format Table)
    Get-FGTFirewallServiceCustom | Format-Table

    name                     q_origin_key             proxy   category                             protocol     helper iprange fqdn tcp-portrange
    ----                     ------------             -----   --------                             --------     ------ ------- ---- -------------
    DNS                      DNS                      disable Network Services                     TCP/UDP/SCTP auto   0.0.0.0      53
    HTTP                     HTTP                     disable Web Access                           TCP/UDP/SCTP auto   0.0.0.0      80
    HTTPS                    HTTPS                    disable Web Access                           TCP/UDP/SCTP auto   0.0.0.0      443
    IMAP                     IMAP                     disable Email                                TCP/UDP/SCTP auto   0.0.0.0      143
    IMAPS                    IMAPS                    disable Email                                TCP/UDP/SCTP auto   0.0.0.0      993
    [...]

# Modify a Service Custom (tcp_port, comment ...)
     Get-FGTFirewallServiceCustom MyServiceCustomTCP8080 | Set-fGTFirewallServiceCustom -tcp_port 8080-8081 -comment "My new Comment"

    name                : MyServiceCustomTCP8080
    q_origin_key        : MyServiceCustomTCP8080
    proxy               : disable
    category            :
    protocol            : TCP/UDP/SCTP
    helper              : auto
    iprange             : 0.0.0.0
    fqdn                :
    tcp-portrange       : 8080-8081
    udp-portrange       :q
    sctp-portrange      :
    [...]
    comment             : My new Comment
    [...]

# Remove a Service Custom
    Get-FGTFirewallServiceCustom MyServiceCustomTCP8080 | Remove-FGTFirewallServiceCustom

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Firewall Service Custom" on target "MyServiceCustomTCP8080".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
```

#### Service Group

You can create a new Service Group `Add-FGTFirewallServiceGroup`, retrieve its information `Get-FGTFirewallServiceGroup`,
modify its properties `Set-FGTFirewallServiceGroup`, copy/clone its properties `Copy-FGTFirewallServiceGroup`,
Add member to Address Group `Add-FGTFirewallServiceGroup` and remove member `Remove-FGTFirewallServiceGroup`,
or delete it `Remove-FGTFirewallServiceGroup`.  


```powershell

# Get information about ALL Service Group (using Format Table)
    Get-FGTFirewallServiceGroup | Format-Table

    name            q_origin_key    uuid                                 uuid-idx proxy   member
    ----            ------------    ----                                 -------- -----   ------
    Email Access    Email Access    93335026-dfc4-51ef-c42b-629ab4282816    15893 disable {@{name=DNS; 
    Exchange Server Exchange Server 9333715a-dfc4-51ef-6183-f0a310646069    15896 disable {@{name=DCE-RPC
    Web Access      Web Access      933360b6-dfc4-51ef-0736-afa8ac22a85d    15894 disable {@{name=DNS
    Windows AD      Windows AD      93336746-dfc4-51ef-2780-4461a70290e0    15895 disable {@{name=DCE-RPC


# Add a Service Group with HTTP and HTTPS
    Add-FGTFirewallServiceGroup -name "My Service Group" -member HTTP, HTTPS

    name          : My Service Group
    q_origin_key  : My Service Group
    uuid          : b618b7a8-e03a-51f0-d9ee-34d958d1c624
    uuid-idx      : 42622
    proxy         : disable
    member        : {@{name=HTTP; q_origin_key=HTTP}, @{name=HTTPS; q_origin_key=HTTPS}}
    comment       :
    color         : 0
    fabric-object : disable

# Add DNS member to existing User Group
    Get-FGTFirewallServiceGroup -name "My Service Group" | Add-FGTFirewallServiceGroupMember -member DNS

    name          : My Service Group
    q_origin_key  : My Service Group
    uuid          : b618b7a8-e03a-51f0-d9ee-34d958d1c624
    uuid-idx      : 42622
    proxy         : disable
    member        : {@{name=HTTP; q_origin_key=HTTP}, @{name=HTTPS; q_origin_key=HTTPS}, @{name=DNS; q_origin_key=DNS}}
    comment       :
    color         : 0
    fabric-object : disable

# Remove HTTP member to existing User Group
    Get-FGTFirewallServiceGroup -name "My Service Group" | Remove-FGTFirewallServiceGroupMember -member HTTP

    name          : My Service Group
    q_origin_key  : My Service Group
    uuid          : b618b7a8-e03a-51f0-d9ee-34d958d1c624
    uuid-idx      : 42622
    proxy         : disable
    member        : {@{name=HTTPS; q_origin_key=HTTPS}, @{name=DNS; q_origin_key=DNS}}
    comment       :
    color         : 0
    fabric-object : disable

# Modify a Service Group (set member...)
    Get-FGTFirewallServiceGroup -name "My Service Group" | Set-FGTFirewallServiceGroup -member DNS

    name          : My Service Group
    q_origin_key  : My Service Group
    uuid          : b618b7a8-e03a-51f0-d9ee-34d958d1c624
    uuid-idx      : 42622
    proxy         : disable
    member        : {@{name=DNS; q_origin_key=DNS}}
    comment       :
    color         : 0
    fabric-object : disable

# Copy/Clone a Service Group
    Get-FGTFirewallServiceGroup -name "My Service Group" | Copy-FGTFirewallServiceGroup -name "My Service User Group"

    name          : My Service User Group
    q_origin_key  : My Service User Group
    uuid          : 654866b0-e03b-51f0-37cd-775ca4fbef17
    uuid-idx      : 43059
    proxy         : disable
    member        : {@{name=DNS; q_origin_key=DNS}}
    comment       :
    color         : 0
    fabric-object : disable

# Remove a Service Group
    Get-FGTFirewallServiceGroup -name "My Service Group" | Remove-FGTFirewallServiceGroup

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Firewall Service Group" on target "My Service Group".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### VPN IPsec

#### VPN IPsec Interface Phase 1

You can create a new VPN IPsec (Interface Phase1) `Add-FGTVpnIpsecPhase1Interface`,
retrieve its information `Get-FGTVpnIpsecPhase1Interface`, modify its properties `Set-FGTVpnIpsecPhase1Interface`
or delete it `Remove-FGTVpnIpsecPhase1Interface`.

```powershell

# Create a static VPN IPsec Phase 1 Interface named PowerFGT_VPN with interface port2 with Remote Gateway 192.0.2.1
    Add-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN -type static -interface port2 -psksecret MySecret -remotegw 192.0.2.1

    name                        : PowerFGT_VPN
    q_origin_key                : PowerFGT_VPN
    type                        : static
    interface                   : port2
    ip-version                  : 4
    ike-version                 : 1
    local-gw                    : 0.0.0.0
    local-gw6                   : ::
    remote-gw                   : 192.0.2.1
    [...]


# Get information about ALL VPN IPsec Phase 1 Interface (using Format Table)
    Get-FGTVpnIpsecPhase1Interface | Format-Table

    name          q_origin_key  type    interface ip-version ike-version local-gw local-gw6 remote-gw remote-gw6
    ----          ------------  ----    --------- ---------- ----------- -------- --------- --------- ----------
    PowerFGT_VPN  PowerFGT_VPN  static  port2     4          1           0.0.0.0  ::        192.0.2.1 ::
    PowerFGT_VPN2 PowerFGT_VPN2 dynamic port2     4          2           0.0.0.0  ::        0.0.0.0   ::

# Modify a VPN IPsec 1 Interface (dhgrp, autodiscovery ...)
    Get-FGTVpnIpsecPhase1Interface PowerFGT_VPN | Set-FGTVpnIpsecPhase1Interface -dhgrp 14 -autodiscoverysender

    name                        : PowerFGT_VPN
    q_origin_key                : PowerFGT_VPN
    type                        : static
    interface                   : port2
    ip-version                  : 4
    ike-version                 : 1
    local-gw                    : 0.0.0.0
    local-gw6                   : ::
    remote-gw                   : 192.0.2.1
    [...]
    dhgrp                       : 14
    [...]
    auto-discovery-sender       : enable


# Remove a VPN IPsec 1 Interface
    Get-FGTVpnIpsecPhase1Interface PowerFGT_VPN | Remove-FGTVpnIpsecPhase1Interface

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Vpn IPsec Phase 1 Interface" on target "PowerFGT_VPN".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
```

#### VPN IPsec Interface Phase 2

You can create a new VPN IPsec (Interface Phase2) `Add-FGTVpnIpsecPhase2Interface`,
retrieve its information `Get-FGTVpnIpsecPhase2Interface`, modify its properties `Set-FGTVpnIpsecPhase2Interface`
or delete it `Remove-FGTVpnIpsecPhase2Interface`.

You need to have VPN IPsec Interface Phase 1 created before 

```powershell

# Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN based on PowerFGT_VPN phase 1 with source network VPN_LOCAL and desination network VPN_REMOTE
    Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Add-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN -srcname VPN_LOCAL -dstname VPN_REMOTE

    name                     : ph2_PowerFGT_VPN
    q_origin_key             : ph2_PowerFGT_VPN
    phase1name               : PowerFGT_VPN
    [...]
    src-name                 : VPN_LOCAL
    src-name6                :
    src-addr-type            : name
    src-end-ip6              : ::
    src-port                 : 0
    dst-name                 : VPN_REMOTE
    dst-name6                :
    dst-addr-type            : name
    dst-end-ip6              : ::
    dst-port                 : 0


# Get information about ALL VPN IPsec Phase 2 Interface (using Format Table)
    Get-FGTVpnIpsecPhase2Interface | Format-Table

    name             q_origin_key     phase1name   dhcp-ipsec proposal         pfs    ipv4-df dhgrp replay keepalive
    ----             ------------     ----------   ---------- --------         ---    ------- ----- ------ ---------
    ph2_PowerFGT_VPN ph2_PowerFGT_VPN PowerFGT_VPN disable    aes256-sha1      enable disable 14 5  enable disable

# Modify a VPN IPsec 2 Interface (comments ...)
    Get-FGTVpnIpsecPhase2Interface ph2_PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -comments "My PowerFGT IPsec Phase2"

    name                     : ph2_PowerFGT_VPN
    q_origin_key             : ph2_PowerFGT_VPN
    phase1name               : PowerFGT_VPN
    [...]
    comments                 : My PowerFGT IPsec Phase2
    [...]


# Remove a VPN IPsec 2 Interface
    Get-FGTVpnIpsecPhase2Interface ph2_PowerFGT_VPN | Remove-FGTVpnIpsecPhase2Interface

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Remove Vpn IPsec Phase 2 Interface" on target "ph2_PowerFGT_VPN".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
```

### Switch

It is possible to `Get` Switch (-Controller) Configuration

* `Get-FGTSwitchFortilinkSettings` Get integrated FortiLink settings for FortiSwitch
* `Get-FGTSwitchGlobal` Get FortiSwitch global settings
* `Get-FGTSwitchGroup` Get FortiSwitch switch groups
* `Get-FGTSwitchLLDPProfile` Get FortiSwitch LLDP profiles
* `Get-FGTSwitchLLDPSettings` Get FortiSwitch LLDP Settings
* `Get-FGTSwitchManagedSwitch` Get FortiSwitch devices that are managed by this FortiGate
* `Get-FGTSwitchProfile` Get FortiSwitch switch profile
* `Get-FGTSwitchSNMPCommunity` Get FortiSwitch SNMP v1/v2c communities globally
* `Get-FGTSwitchSTPInstance` Get FortiSwitch multiple spanning tree protocol (MSTP) instances
* `Get-FGTSwitchSTPSettings` Get FortiSwitch spanning tree protocol (STP)
* `Get-FGTSwitchSystem` Get system-wide switch controller settings
* `Get-FGTSwitchVlanPolicy` Get VLAN policy to be applied on the managed FortiSwitch ports through dynamic-port-policy

### Wireless

It is possible to `Get` Wireless (-Controller) Configuration
* `Get-FGTWirelessGlobal` Get Wireless Global Setting
* `Get-FGTWirelessSetting` Get Wireless Setting
* `Get-FGTWirelessSSIDPolicy` List Wireless SSID Policy
* `Get-FGTWirelessVAP` List Wireless VAP (Virtual Access Points)
* `Get-FGTWirelessVAPGroup` List Wireless VAP Group
* `Get-FGTWirelessWAGProfile` List Wireless Wireless Access Gateway Profile
* `Get-FGTWirelessWTP` List Wireless WTP (Wireless Termination Points)
* `Get-FGTWirelessWTPGroup` List Wireless WTP Group
* `Get-FGTWirelessWTPProfile` List Wireless WTP Profile

### ZTNA

It is possible to `Get` ZTNA (Access Proxy) Configuration
* `Get-FGTFirewallAccessProxy` Get Firewall Access Proxy

### Monitor

It is possible to `monitor` FortiGate

* `Get-FGTMonitorFirewallAddressDynamic` List of Fabric Connector address objects and the IPs they resolve to.
* `Get-FGTMonitorFirewallAddressFQDN` List of FQDN address objects and the IPs they resolved to
* `Get-FGTMonitorFirewallPolicy` List traffic statistics for firewall policies
* `Get-FGTMonitorFirewallSession` List all active firewall sessions
* `Get-FGTMonitorRouterBGPNeighbors` List all discovered BGP neighbors
* `Get-FGTMonitorRouterIPv4` List all active IPv4 routing table entries
* `Get-FGTMonitorRouterOSPFNeighbors` List all discovered OSPF neighbors
* `Get-FGTMonitorLicenseStatus` Get current license & registration status
* `Get-FGTMonitorNetworkARP` Get IPv4 ARP table
* `Get-FGTMonitorSystemConfigBackup` Backup system config
* `Get-FGTMonitorSystemDHCP` List all DHCP leases
* `Get-FGTMonitorSystemFirmware` Retrieve a list of firmware images available to use for upgrade on this device
* `Get-FGTMonitorSystemInterface` Retrieve statistics for all system interfaces
* `Get-FGTMonitorSystemInterfaceTransceivers` Get a list of transceivers being used by the FortiGate
* `Get-FGTMonitorSystemHAChecksum` List of checksums for members of HA cluster
* `Get-FGTMonitorSystemHAPeer` Get configuration of peer(s) in HA cluster
* `Get-FGTMonitorUserFortitoken` Retrieve a map of FortiTokens and their status
* `Get-FGTMonitorUtmApplicationCategories` Get list of (UTM) Application Categories
* `Get-FGTMonitorVpnIPsec` Return active IPsec VPNs
* `Get-FGTMonitorVpnSsl` Retrieve a list of all SSL-VPN sessions and sub-sessions and Return statistics about the SSL-VPN
* `Get-FGTMonitorWebfilterCategories` Return FortiGuard web filter categories

to get API uri, you can use `Invoke-FGTRestMethod api/v2/monitor/?action=schema` for get list of uri for monitor

### Log

#### Traffic

It is possible to get `log traffic` of FortiGate.

You can get the following type log
* disk
* fortianalyzer
* forticloud
* memory

and subtype
* forward
* local
* multicast
* sniffer
* fortiview
* threat

by default, it is only first 20 rows availables (use -rows parameter )’
/!\ you can get issue if you ask too many rows on small appliance /!\

can also filter by
* Source IP (-srcip)
* Source Interface (-srcintf)
* Destination IP (-dstip)
* Destination Interface (-dstintf)
* Destination Port (-dstport)
* Action (-action)
* Policy ID (-policyid)
* Policy UUID (-poluuid)
* Duration (-duration)

for Example

```powershell
    #Get Log Traffic from memory on subtype forward and 10 000 rows

    Get-FGTLogTraffic -type memory -subtype forward -rows 10000 | Format-Table
    date       time               eventtime tz    logid      type    subtype level   vd   srcip
    ----       ----               --------- --    -----      ----    ------- -----   --   -----
    2022-03-06 22:52:28 1646635948633219391 -0800 0000000013 traffic forward notice  root 103.39.247.123
    2022-03-06 22:52:28 1646635948603208109 -0800 0000000013 traffic forward notice  root 103.39.247.123
    2022-03-06 22:52:28 1646635948593207059 -0800 0000000013 traffic forward notice  root 103.39.247.123
    2022-03-06 22:52:28 1646635948483209427 -0800 0000000022 traffic forward notice  root 10.88.130.131
    2022-03-06 22:52:28 1646635948483206444 -0800 0000000022 traffic forward notice  root 10.88.102.99
    2022-03-06 22:52:28 1646635948443205594 -0800 0000000022 traffic forward notice  root 10.88.110.122
    2022-03-06 22:52:28 1646635948443208223 -0800 0000000022 traffic forward notice  root 10.88.2.21
    2022-03-06 22:52:28 1646635948333207985 -0800 0000000013 traffic forward notice  root 216.251.148.178
    2022-03-06 22:52:28 1646635948283206523 -0800 0000000022 traffic forward notice  root 10.88.130.131
    2022-03-06 22:52:27 1646635948153206637 -0800 0001000014 traffic local   notice  root 127.0.0.1
    2022-03-06 22:52:27 1646635948083207799 -0800 0001000014 traffic local   notice  root 127.0.0.1
    2022-03-06 22:52:27 1646635948083211212 -0800 0001000014 traffic local   notice  root 127.0.0.1
    2022-03-06 22:52:27 1646635948163208549 -0800 0000000022 traffic forward notice  root 10.88.110.122
    [...]
```

you can also get some extra info using -extra parameter :
* reverse_lookup to get name of IP (found by the fortigate)
* country_id to get country of IP Address

You can also select the 'timeline' using -since parameter 1h(our), 1d(ay), 7d(ays), 30(days), only for Fortiguard type

You can use also `Get-FGTLogSetting` for get setting for Log (Syslogd, FortiAnalyzer...)

#### Traffic

It is possible to get `log traffic` of FortiGate.

You can get the following type log
* disk
* fortianalyzer
* forticloud
* memory

and subtype
* vpn;
* user
* router
* wireless
* wad
* endpoint
* ha
* compliance-check
* security-rating
* fortiextender
* connector
* system

by default, it is only first 20 rows availables (use -rows parameter )’

for Example

```powershell
    #Get Log Event from fortivloud on subtype system and select column

    Get-FGTLogEvent -type forticloud -subtype system | select date, type, subtype, system, logdesc, msg | ft

    date       type  subtype system logdesc                                    msg
    ----       ----  ------- ------ -------                                    ---
    2025-11-17 event system         Admin login successful                     Administrator admin logged in successfully from https(192.0.2.120)
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  56, concurrent sessions:  215, setup-rate: 1
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  56, concurrent sessions:  341, setup-rate: 1
    2025-11-17 event system         Attribute configured                       Edit system.global 
    2025-11-17 event system         Device in the Security Fabric was updated. A device in the Security Fabric was updated.
    2025-11-17 event system         Admin login successful                     Administrator admin logged in successfully from https(192.0.2.125)
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  357, setup-rate: 4
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  325, setup-rate: 0
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  229, setup-rate: 0
    2025-11-17 event system         DHCP statistics                            DHCP statistics
    2025-11-17 event system         DHCP statistics                            DHCP statistics
    2025-11-17 event system         DHCP Ack log                               DHCP server sends a DHCPACK
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  191, setup-rate: 0
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  274, setup-rate: 0
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  197, setup-rate: 0
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  378, setup-rate: 92
    2025-11-17 event system         DHCP Ack log                               DHCP server sends a DHCPACK
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  268, setup-rate: 9
    2025-11-17 event system         System performance statistics              Performance statistics: average CPU: 0, memory:  55, concurrent sessions:  247, setup-rate: 
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
and for each Get (cmdb) cmdlet, you can use -schema parameter for get API Call schema (parameter, default value...)  
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

### Proxy

There is also cmdlet for Proxy
- Proxy Address (Add/Copy/Get/Remove-FGTFirewallProxyAddress)
- Proxy Address Group (Add/Copy/Get/Set/Remove-FGTFirewallProxyAddressGroup)
- Proxy Policy (Add/Get/Remove-FGTFirewallProxyPolicy)

For Proxy Policy, it is possible to specific explict proxy or transparent
For FortiGate 6.0.x, you need to enable proxy mode before (and enable feature)

### Local In Policy

There is also cmdlet for Local in Policy

You can create a new Local In Policy `Add-FGTFirewallLocalInPolicy`, retrieve its information `Get-FGTFirewallLocalInPolicy`
Add member to source or destinationn address `Add-FGTFirewallLocalInPolicyMember` and remove member `Add-FGTFirewallLocalInPolicyMember`,
set it `Set-FGTFirewallLocalInPolicy` or delete it `Remove-FGTFirewalLocalInPolicy`.

### Connecting with API Token

If you have a REST API administrator account setup, you can connect with the API

```powershell
Connect-FGT 192.0.2.1 -ApiToken "yourtoken"
```

You can use API Token with HTTPS (or HTTP with FortiOS > 7.0.x but not recommended)

A REST API administrator account can be setup using the following FortiOS CLI commands:

```
config system accprofile
    edit "api_powerfgt"
        set netgrp read-write
        set fwgrp read-write
        set vpngrp read-write
        set system-diagnostics disable
    next
end

config system api-user
    edit "myaccount_powerfgt"
        set accprofile "api_powerfgt"
        config trusthost
            edit 1
                set ipv4-trusthost 192.0.2.0 255.255.255.0
            next
        end
    next
end
```

### MultiConnection

From release 0.3.0, it is possible to connect on same times to multi FortiGate
You need to use -connection parameter to cmdlet

For example to get interface of 2 FortiGate

```powershell
# Connect to first FortiGate
    $fw1 = Connect-FGT 192.0.2.1 -SkipCertificateCheck -DefaultConnection:$false

#DefaultConnection set to false is not mandatory but only don't set the connection info on global variable

# Connect to second FortiGate
    $fw2 = Connect-FGT 192.0.2.2 -SkipCertificateCheck -DefaultConnection:$false

# Get Interface for first FortiGate
    Get-FGTSystemInterface -connection $fw1 | Format-Table

    q_origin_key  name          vdom vrf cli-conn-status fortilink mode   distance priority dhcp-relay-service
    ------------  ----          ---- --- --------------- --------- ----   -------- -------- ------------------
    DCFW          DCFW          root   0               0 disable   static        5        0 enable
    FITNUC        FITNUC        root   0               0 disable   static        5        0 disable
....

# Get Interface for second FortiGate
    Get-FGTSystemInterface -connection $fw2 | Format-Table

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

### Deploy-VM

You can deploy FortiGate OVA (vapp), you need VMware.PowerCLI module and FortiGate OVF (available on support web site)

```powershell
    $fortiBuildParams = @{
        ovf_path                    = "C:\FortiGate-VM64.vapp.ovf"
        vm_host                     = "MyHost"
        datastore                   = "MyDataStore"
        Cluster                     = "MyCluster"
        name_vm                     = "PowerFGT"
        hostname                    = "PowerFGT"
        dns_primary                 = "192.0.2.3"
        dns_secondary               = "192.0.2.4"
        int0_network_mode           = "Static"
        int0_gateway                = "192.0.2.254"
        int0_ip                     = "192.0.2.1"
        int0_netmask                = "255.255.255.0"
        int0_port_group             = "PG-PowerFGT"
        net_adapter                 = "vmxnet3"
    }
    Deploy-FGTVm @fortiBuildParams

    PowerFGT is ready to use (http://192.0.2.1) (need to Start VM !)

```

# Issue

## Unable to connect (certificate)

if you use `Connect-FGT` and get `Unable to Connect (certificate)`

The issue coming from use Self-Signed or Expired Certificate for Firewall Management  
Try to connect using `Connect-FGT -SkipCertificateCheck`

## Unable to connect

You can use also `Connect-FGT -httpOnly` for connect using HTTP (NOT RECOMMENDED !)

# How to contribute

Contribution and feature requests are more than welcome. Please use the following methods:

  * For bugs and [issues](https://github.com/FortiPower/PowerFGT/issues), please use the [issues](https://github.com/FortiPower/PowerFGT/issues) register with details of the problem.
  * For Feature Requests, please use the [issues](https://github.com/FortiPower/PowerFGT/issues) register with details of what's required.
  * For code contribution (bug fixes, or feature request), please request fork PowerFGT, create a feature/fix branch, add tests if needed then submit a pull request.

# Contact

Currently, [@alagoutte](#author) started this project and will keep maintaining it. Reach out to me via [Twitter](#author), Email (see top of file) or the [issues](https://github.com/FortiPower/PowerFGT/issues) Page here on GitHub. If you want to contribute, also get in touch with me.

# List of available command
```powershell
Add-FGTFirewallAddress
Add-FGTFirewallAddressGroup
Add-FGTFirewallAddressGroupMember
Add-FGTFirewallLocalInPolicy
Add-FGTFirewallLocalInPolicyMember
Add-FGTFirewallPolicy
Add-FGTFirewallPolicyMember
Add-FGTFirewallProxyAddress
Add-FGTFirewallProxyAddressGroup
Add-FGTFirewallProxyAddressGroupMember
Add-FGTFirewallProxyPolicy
Add-FGTFirewallServiceCustom
Add-FGTFirewallServiceGroup
Add-FGTFirewallServiceGroupMember
Add-FGTFirewallVip
Add-FGTFirewallVipGroup
Add-FGTFirewallVipGroupMember
Add-FGTRouterStatic
Add-FGTSystemAdmin
Add-FGTSystemInterface
Add-FGTSystemInterfaceMember
Add-FGTSystemSDNConnector
Add-FGTSystemZone
Add-FGTSystemZoneMember
Add-FGTUserGroup
Add-FGTUserGroupMember
Add-FGTUserLDAP
Add-FGTUserLocal
Add-FGTUserRADIUS
Add-FGTUserTACACS
Add-FGTVpnIpsecPhase1Interface
Add-FGTVpnIpsecPhase2Interface
Confirm-FGTAddress
Confirm-FGTAddressGroup
Confirm-FGTFirewallLocalInPolicy
Confirm-FGTFirewallPolicy
Confirm-FGTFirewallProxyPolicy
Confirm-FGTInterface
Confirm-FGTProxyAddress
Confirm-FGTProxyAddressGroup
Confirm-FGTRouterStatic
Confirm-FGTSDNConnector
Confirm-FGTServiceCustom
Confirm-FGTServiceGroup
Confirm-FGTSystemAdmin
Confirm-FGTUserGroup
Confirm-FGTUserLDAP
Confirm-FGTUserLocal
Confirm-FGTUserRADIUS
Confirm-FGTUserTACACS
Confirm-FGTVip
Confirm-FGTVipGroup
Confirm-FGTVpnIpsecPhase1Interface
Confirm-FGTVpnIpsecPhase2Interface
Confirm-FGTZone
Connect-FGT
Copy-FGTFirewallAddress
Copy-FGTFirewallAddressGroup
Copy-FGTFirewallProxyAddress
Copy-FGTFirewallProxyAddressGroup
Copy-FGTFirewallServiceGroup
Copy-FGTFirewallVipGroup
Copy-FGTUserGroup
Deploy-FGTVm
Disconnect-FGT
Get-FGTAntivirusProfile
Get-FGTApplicationList
Get-FGTDnsfilterProfile
Get-FGTFirewallAccessProxy
Get-FGTFirewallAddress
Get-FGTFirewallAddressGroup
Get-FGTFirewallInternetServiceName
Get-FGTFirewallIPPool
Get-FGTFirewallLocalInPolicy
Get-FGTFirewallPolicy
Get-FGTFirewallProxyAddress
Get-FGTFirewallProxyAddressGroup
Get-FGTFirewallProxyPolicy
Get-FGTFirewallServiceCustom
Get-FGTFirewallServiceGroup
Get-FGTFirewallSSLSSHProfile
Get-FGTFirewallVip
Get-FGTFirewallVipGroup
Get-FGTIpsSensor
Get-FGTLogEvent
Get-FGTLogSetting
Get-FGTLogTraffic
Get-FGTMonitorFirewallAddressDynamic
Get-FGTMonitorFirewallAddressFQDN
Get-FGTMonitorFirewallPolicy
Get-FGTMonitorFirewallSession
Get-FGTMonitorLicenseStatus
Get-FGTMonitorNetworkARP
Get-FGTMonitorRouterBGPNeighbors
Get-FGTMonitorRouterIPv4
Get-FGTMonitorRouterOSPFNeighbors
Get-FGTMonitorSystemConfigBackup
Get-FGTMonitorSystemDHCP
Get-FGTMonitorSystemFirmware
Get-FGTMonitorSystemHAChecksum
Get-FGTMonitorSystemHAPeer
Get-FGTMonitorSystemInterface
Get-FGTMonitorSystemInterfaceDHCPStatus
Get-FGTMonitorSystemInterfaceTransceivers
Get-FGTMonitorUserFortitoken
Get-FGTMonitorUtmApplicationCategories
Get-FGTMonitorVpnIPsec
Get-FGTMonitorVpnSsl
Get-FGTMonitorWebfilterCategories
Get-FGTRouterBGP
Get-FGTRouterOSPF
Get-FGTRouterPolicy
Get-FGTRouterStatic
Get-FGTSwitchFortilinkSettings
Get-FGTSwitchGlobal
Get-FGTSwitchGroup
Get-FGTSwitchLLDPProfile
Get-FGTSwitchLLDPSettings
Get-FGTSwitchManagedSwitch
Get-FGTSwitchProfile
Get-FGTSwitchSNMPCommunity
Get-FGTSwitchSTPInstance
Get-FGTSwitchSTPSettings
Get-FGTSwitchSystem
Get-FGTSwitchVlanPolicy
Get-FGTSystemAdmin
Get-FGTSystemDHCPServer
Get-FGTSystemDns
Get-FGTSystemDnsServer
Get-FGTSystemGlobal
Get-FGTSystemHA
Get-FGTSystemInterface
Get-FGTSystemSDNConnector
Get-FGTSystemSDWAN
Get-FGTSystemSettings
Get-FGTSystemVdom
Get-FGTSystemVirtualSwitch
Get-FGTSystemVirtualWANLink
Get-FGTSystemZone
Get-FGTUserGroup
Get-FGTUserLDAP
Get-FGTUserLocal
Get-FGTUserRADIUS
Get-FGTUserSAML
Get-FGTUserTACACS
Get-FGTVpnIpsecPhase1Interface
Get-FGTVpnIpsecPhase2Interface
Get-FGTVpnSSLClient
Get-FGTVpnSSLPortal
Get-FGTVpnSSLSettings
Get-FGTWebfilterProfile
Get-FGTWirelessGlobal
Get-FGTWirelessSetting
Get-FGTWirelessSSIDPolicy
Get-FGTWirelessVAP
Get-FGTWirelessVAPGroup
Get-FGTWirelessWAGProfile
Get-FGTWirelessWTP
Get-FGTWirelessWTPGroup
Get-FGTWirelessWTPProfile
Invoke-FGTRestMethod
Move-FGTFirewallLocalInPolicy
Move-FGTFirewallPolicy
Remove-FGTFirewallAddress
Remove-FGTFirewallAddressGroup
Remove-FGTFirewallAddressGroupMember
Remove-FGTFirewallLocalInPolicy
Remove-FGTFirewallLocalInPolicyMember
Remove-FGTFirewallPolicy
Remove-FGTFirewallPolicyMember
Remove-FGTFirewallProxyAddress
Remove-FGTFirewallProxyAddressGroup
Remove-FGTFirewallProxyAddressGroupMember
Remove-FGTFirewallProxyPolicy
Remove-FGTFirewallServiceCustom
Remove-FGTFirewallServiceGroup
Remove-FGTFirewallServiceGroupMember
Remove-FGTFirewallVip
Remove-FGTFirewallVipGroup
Remove-FGTFirewallVipGroupMember
Remove-FGTRouterStatic
Remove-FGTSystemAdmin
Remove-FGTSystemInterface
Remove-FGTSystemInterfaceMember
Remove-FGTSystemSDNConnector
Remove-FGTSystemZone
Remove-FGTSystemZoneMember
Remove-FGTUserGroup
Remove-FGTUserGroupMember
Remove-FGTUserLDAP
Remove-FGTUserLocal
Remove-FGTUserRADIUS
Remove-FGTUserTACACS
Remove-FGTVpnIpsecPhase1Interface
Remove-FGTVpnIpsecPhase2Interface
Set-FGTCipherSSL
Set-FGTConnection
Set-FGTFirewallAddress
Set-FGTFirewallAddressGroup
Set-FGTFirewallLocalInPolicy
Set-FGTFirewallPolicy
Set-FGTFirewallProxyAddressGroup
Set-FGTFirewallServiceCustom
Set-FGTFirewallServiceGroup
Set-FGTFirewallVipGroup
Set-FGTMonitorUserLocalChangePassword
Set-FGTRouterBGP
Set-FGTRouterOSPF
Set-FGTSystemAdmin
Set-FGTSystemGlobal
Set-FGTSystemInterface
Set-FGTSystemSDNConnector
Set-FGTSystemSettings
Set-FGTSystemZone
Set-FGTUntrustedSSL
Set-FGTUserGroup
Set-FGTUserLDAP
Set-FGTUserLocal
Set-FGTUserRADIUS
Set-FGTUserTACACS
Set-FGTVpnIpsecPhase1Interface
Set-FGTVpnIpsecPhase2Interface
Show-FGTException
```

# Author

**Alexis La Goutte**
- <https://github.com/alagoutte>
- <https://twitter.com/alagoutte>

# Contributors

- Alex Bush
- Arthur Heijnen
- Benjamin Perrier
- Brett Pound
- Cédric Moreau
- Dave Hope
- Evan Chisholm
- Jelmer Jaarsma
- Johan Kummeneje
- Kevin Shu
- Sylvain Gomez

Sort by name (*git shortlog -s*)

# Special Thanks

- Warren F. for his [blog post](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/) 'Building a Powershell module'
- Erwan Quelin for help about Powershell

# License

Copyright 2019-2025 Alexis La Goutte and the community.
