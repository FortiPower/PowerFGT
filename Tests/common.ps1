#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
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

. ../credential.ps1
#TODO: Add check if no ipaddress/login/password info...

$script:mysecpassword = ConvertTo-SecureString $password -AsPlainText -Force

if ($httpOnly) {
    Connect-FGT -Server $ipaddress -Username $login -password $mysecpassword -httpOnly
}
else {
    Connect-FGT -Server $ipaddress -Username $login -password $mysecpassword -SkipCertificateCheck
}
