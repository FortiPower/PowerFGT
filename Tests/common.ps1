#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.1.0" }

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
Param()
# default settings for test...
$script:pester_address1 = "pester_address %/*?1"
$script:pester_address2 = "pester_address2"
$script:pester_address3 = "pester_address3"
$script:pester_address4 = "pester_address4"
$script:pester_address5 = "pester_address5"
$script:pester_address6 = "pester_address6"
$script:pester_addressgroup1 = "pester_addressgroup %/*?1"
$script:pester_addressgroup2 = "pester_addressgroup2"
$script:pester_vip1 = "pester_vip %/*?1"
$script:pester_vip2 = "pester_vip2"
$script:pester_vip3 = "pester_vip3"
$script:pester_vip4 = "pester_vip4"
$script:pester_vipgroup1 = "pester_vipgroup %/*?1"
$script:pester_vipgroup2 = "pester_vipgroup2"
$script:pester_policy1 = "pester_policy %/*?1"
$script:pester_policy2 = "pester_policy2"
$script:pester_policy3 = "pester_policy3"
$script:pester_proxyaddress1 = "pester_proxyaddress %/*?1"
$script:pester_proxyaddress2 = "pester_proxyaddress2"
$script:pester_proxyaddress3 = "pester_proxyaddress3"
$script:pester_proxyaddress4 = "pester_proxyaddress4"
$script:pester_proxyaddressgroup1 = "pester_proxyaddressgroup %/*?1"
$script:pester_proxyaddressgroup2 = "pester_proxyaddressgroup2"
$script:pester_port1 = "port7"
$script:pester_port2 = "port8"
$script:pester_port3 = "port9"
$script:pester_port4 = "port10"
$script:pester_int1 = "int1"
$script:pester_int2 = "int2"
$script:pester_vlanid1 = "10"
$script:pester_vpn1 = "pester_vpn1"
$script:pester_vpn2 = "pester_vpn2"
$script:pester_vpn1_ph2 = "pester_vpn %/*?1_ph2"
$script:pester_vpn2_ph2 = "pester_vpn2_ph2"
$script:pester_zone1 = "pester_zone %/*?1"
$script:pester_zone2 = "pester_zone2"
$script:pester_userlocal = "pester_userlocal"
$script:pester_userlocalpassword = ConvertTo-SecureString "pester_userlocalpassword" -AsPlainText -Force
$script:pester_userldap = "pester_ldapserver"
$script:pester_userldapserver1 = "pesterldapserver1.powerfgt"
$script:pester_userldapserver2 = "pesterldapserver2.powerfgt"
$script:pester_userldapserver3 = "pesterldapserver3.powerfgt"
$script:pester_userldappassword = ConvertTo-SecureString "pester_userldappassword" -AsPlainText -Force
$script:pester_userldappasswordchanged = ConvertTo-SecureString "pester_userldappasswordchanged" -AsPlainText -Force
$script:pester_userlocal2 = "pester_userlocal2"
$script:pester_userlocal3 = "pester_userlocal3"
$script:pester_userlocal4 = "pester_userlocal4"
$script:pester_usergroup1 = "pester_usergroup1"
$script:pester_usergroup2 = "pester_usergroup2"
$script:pester_usertacacs = "pester_usertacacs"
$script:pester_usertacacsserver1 = "pestertacacsserver1.powerfgt"
$script:pester_usertacacsserver2 = "pestertacacsserver2.powerfgt"
$script:pester_usertacacsserver3 = "pestertacacsserver3.powerfgt"
$script:pester_usertacacs_key = ConvertTo-SecureString "pester_usertacacskey" -AsPlainText -Force
$script:pester_userradius = "pester_userradius"
$script:pester_userradiusserver1 = "pesterradiusserver1.powerfgt"
$script:pester_userradiusserver2 = "pesterradiusserver2.powerfgt"
$script:pester_userradiusserver3 = "pesterradiusserver3.powerfgt"
$script:pester_userradius_secret = ConvertTo-SecureString "pester_userradiussecret" -AsPlainText -Force
$script:pester_sdnconnector1 = "pester_sdnconnector1"
$script:pester_sdnconnector2 = "pester_sdnconnector2"
$script:pester_sdnconnectorpassword = ConvertTo-SecureString "pester_sdnconnectorpassword" -AsPlainText -Force
$script:pester_servicecustom1 = "pester_servicecustom1"
$script:pester_servicegroup1 = "pester_servicegroup1"
$script:pester_servicegroup2 = "pester_servicegroup2"
$script:pester_service1 = "pester_service1"
$script:pester_service2 = "pester_service2"
$script:pester_service3 = "pester_service3"
$script:pester_service4 = "pester_service4"

. ../credential.ci.ps1
#TODO: Add check if no ipaddress/login/password info...

$script:mysecpassword = ConvertTo-SecureString $password -AsPlainText -Force
$script:mywrongpassword = ConvertTo-SecureString "WrongPassword" -AsPlainText -Force

$script:invokeParams = @{
    Server   = $ipaddress;
    username = $login;
    password = $mysecpassword;
}

if ($httpOnly) {
    if ($null -eq $port) {
        $script:port = '80'
    }
}
else {
    if ($null -eq $port) {
        $script:port = '443'
    }
}
$invokeParams.add('SkipCertificateCheck', $SkipCertificateCheck)
$invokeParams.add('httpOnly', $httpOnly)
$invokeParams.add('port', $port)

#Make a connection for check info and store version (used for some test...)
$fgt = Connect-FGT @invokeParams
$script:fgt_version = $fgt.version

$VersionIs60WithNoHA = $false
if ($fgt_version -lt [version]"6.2.0") {
    if ( (Get-FGTSystemHA).mode -eq "standalone") {
        $VersionIs60WithNoHA = $true
    }
}

$VersionIs64 = ($fgt_version -gt [version]"6.4.0" -and $fgt_version -lt [version]"6.5.0")

Disconnect-FGT -confirm:$false
