#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

# Copy this file to credential.ps1 (on Tests folder) and change connection settings..

$script:ipaddress = "10.44.23.213"
$script:login = "admin"
$script:password = "enable"
$script:httpOnly = $true
#$script:port = "80"
#$script:apitoken = "yourtoken"
$script:SkipCertificateCheck = $true
$script:ci = $false
$script:oldauth = $false
#$script:vdom = "MyVDOM"

#default settings use for test, can be override if needed...
$script:pester_address1 = "pester_address1"
$script:pester_address2 = "pester_address2"
$script:pester_address3 = "pester_address3"
$script:pester_address4 = "pester_address4"

$script:pester_addressgroup = "pester_addressgroup"

$script:pester_vip1 = "pester_vip1"
$script:pester_policy1 = "pester_policy1"