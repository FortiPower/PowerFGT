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
$script:pester_address1 = "pester_address1"
$script:pester_address2 = "pester_address2"
$script:pester_address3 = "pester_address3"
$script:pester_address4 = "pester_address4"
$script:pester_addressgroup1 = "pester_addressgroup1"
$script:pester_addressgroup2 = "pester_addressgroup2"
$script:pester_vip1 = "pester_vip1"
$script:pester_vip2 = "pester_vip2"
$script:pester_vip3 = "pester_vip3"
$script:pester_vip4 = "pester_vip4"
$script:pester_vipgroup1 = "pester_vipgroup1"
$script:pester_vipgroup2 = "pester_vipgroup2"
$script:pester_policy1 = "pester_policy1"
$script:pester_policy2 = "pester_policy2"
$script:pester_policy3 = "pester_policy3"
$script:pester_proxyaddress1 = "pester_proxyaddress1"
$script:pester_proxyaddress2 = "pester_proxyaddress2"
$script:pester_proxyaddress3 = "pester_proxyaddress3"
$script:pester_proxyaddress4 = "pester_proxyaddress4"
$script:pester_proxyaddressgroup1 = "pester_proxyaddressgroup1"
$script:pester_proxyaddressgroup2 = "pester_proxyaddressgroup2"
$script:pester_port1 = "port7"
$script:pester_port2 = "port8"
$script:pester_port3 = "port9"
$script:pester_port4 = "port10"
$script:pester_int1 = "int1"
$script:pester_int2 = "int2"
$script:pester_vlanid1 = "10"
$script:pester_zone1 = "pester_zone1"
$script:pester_zone2 = "pester_zone2"

. ../credential.ps1
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
    $invokeParams.add('httpOnly', $true)
}
else {
    if ($null -eq $port) {
        $script:port = '443'
    }
    $invokeParams.add('SkipCertificateCheck', $true)
}
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