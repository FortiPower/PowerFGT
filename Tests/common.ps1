#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
Param()
# default settings for test...

. ../credential.ps1
#TODO: Add check if no ipaddress/login/password info...

$script:mysecpassword = ConvertTo-SecureString $password -AsPlainText -Force

if ($httpOnly) {
    Connect-FGT -Server $ipaddress -Username $login -password $mysecpassword -httpOnly
}
else {
    Connect-FGT -Server $ipaddress -Username $login -password $mysecpassword -SkipCertificateCheck
}
