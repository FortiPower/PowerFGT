# PowerFGT Tests

## Pre-Requisites

The tests don't be to be run on PRODUCTION FortiGate ! there is no warning about change on Manager.
It need to be use only for TESTS !

    A Fortigate (VM) with release >= 6.0.x (Tested with 6.0.x, 6.2.x and 6.4.x)
    a user and password for admin account

These are the required modules for the tests

    Pester

## Executing Tests

Assuming you have git cloned the PowerFGT repository. Go on tests folder and copy credentials.example.ps1 to credentials.ps1 and edit to set information about your firewall FortiGate (ipaddress, login, password)

Go after on integration folder and launch all tests via

```powershell
Invoke-Pester *
```

It is possible to custom some settings when launch test (like Firewall Address Object used), you need to uncommented following line on credentials.ps1

```powershell
$pester_address1 = My_address1

...
```

## Executing Individual Tests

Tests are broken up according to functional area. If you are working on Connection functionality for instance, its possible to just run Connection related tests.

Example:

```powershell
Invoke-Pester Connection.Tests.ps1
```

if you only launch a sub test (Describe on pester file), you can use for example to 'Connect to a FortiGate (using HTTP)' part

```powershell
Invoke-Pester Connection.Tests.ps1 -testName "Connect to a FortiGate (using HTTP)"
```

## Known Issues

No known issues (for the moment...)