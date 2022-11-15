#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2022, Cédric Moreau <moreaucedric0 dot gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Add a FortiGate URL Filter

        .DESCRIPTION
        Add a FortiGate URL Filter

        .EXAMPLE
        Add-FGTWebfilterUrlfilter -name myURL1 -id 1 -name MyURL -comment "Added by PowerFGT"

        Add URL Filter object named MyURL with comment

        .EXAMPLE
        Add-FGTWebfilterUrlfilter -name myURL1 -id 1 -name MyURL -comment "Added by PowerFGT" -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable

        Add URL Filter object named MyURL with an url (URL : powerfgt.com, type : simple, action : allow, status : enable)

        .EXAMPLE
        Add-FGTWebfilterUrlfilter -name myURL1 -id 1 -name MyURL -comment "Added by PowerFGT" -url_id 1 -url_type wildcard -url *powerfgt.com -action block -status enable

        Add URL Filter object named MyURL with an url (URL : *powerfgt.com, type : wildcard, action : block, status : enable)

    #>

    Param(
        [Parameter (Mandatory = $false)]
        [string]$id,
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string]$url_id,
        [Parameter (Mandatory = $false)]
        [string]$url_type,
        [Parameter (Mandatory = $false)]
        [string]$url,
        [Parameter (Mandatory = $false)]
        [string]$action,
        [Parameter (Mandatory = $false)]
        [string]$status,
        [Parameter (Mandatory = $false)]
        [string]$exempt,
        [Parameter (Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( Get-FGTWebfilterUrlfilter -connection $connection @invokeParams -name $name ) {
            Throw "Already a URL profile object using the same name"
        }

        $uri = "api/v2/cmdb/webfilter/urlfilter"

        $urlfilter = new-Object -TypeName PSObject

        $urlfilter | add-member -name "name" -membertype NoteProperty -Value $name

        $urlfilter | add-member -name "id" -membertype NoteProperty -Value $id

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_urlfilter | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        $_entry = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('url_id') ) {
            $_entry | add-member -name "id" -membertype NoteProperty -Value $url_id
        }

        if ( $PsBoundParameters.ContainsKey('url_type') ) {
            $_entry | add-member -name "type" -membertype NoteProperty -Value $url_type
        }

        if ( $PsBoundParameters.ContainsKey('url') ) {
            $_entry | add-member -name "url" -membertype NoteProperty -Value $url
        }

        if ( $PsBoundParameters.ContainsKey('action') ) {
            $_entry | add-member -name "action" -membertype NoteProperty -Value $action
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            $_entry | add-member -name "status" -membertype NoteProperty -Value $status
        }

        if ( $PsBoundParameters.ContainsKey('exempt') ) {
            $_entry | add-member -name "exempt" -membertype NoteProperty -Value $exempt
        }

        $_entries = @()
        $_entries += $_entry

        $urlfilter | add-member -name "entries" -membertype NoteProperty -Value $_entries

        Invoke-FGTRestMethod -method "POST" -body $urlfilter -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTWebfilterUrlfilter -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Get list of all URL Filter

        .DESCRIPTION
        Get list of all URL Filter (URL, actions, etc ...)

        .EXAMPLE
        Get-FGTWebfilterUrlfilter

        Get list of all all URL Filter

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -name myFGTURLFilter

        Get URL Filter named myFGTURLFilter

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -name FGT -filter_type contains

        Get URL Filter contains *FGT*

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -id 1

        Get URL Filter with id 1

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -skip

        Get list of all URL Filter but only the relevant attributes

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -vdom vdomX

        Get list of all URL Filter object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$id,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "uiid" {
                $filter_value = $id
                $filter_attribute = "id"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/webfilter/urlfilter' -method 'GET' -connection $connection @invokeParams

        $response.results
    }

    End {
    }
}

function Set-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Configure a FortiGate URL Filter

        .DESCRIPTION
        Change a FortiGate URL Filter (comment, action, status... )

        .EXAMPLE
        $MyFGTUrl = Get-FGTWebfilterUrlfilter -name MyFGTUrl
        PS C:\>$MyFGTUrl | Set-FGTWebfilterUrlfilter -url_id 10 -action block

        Change MyFGTUrl URL ID 10 to value (action) block

        .EXAMPLE
        $MyFGTUrl = Get-FGTWebfilterUrlfilter -name MyFGTUrl
        PS C:\>$MyFGTUrl | Set-FGTWebfilterUrlfilter -url_id 10 -status disable

        Change MyFGTUrl URL ID 10 to value (status) disable

        .EXAMPLE
        $MyFGTUrl = Get-FGTWebfilterUrlfilter -name MyFGTUrl
        PS C:\>$MyFGTUrl | Set-FGTWebfilterUrlfilter -comment 'Changed by PowerFGT"

        Change MyFGTUrl to set comment to "Changed by PowerFGT"

        .EXAMPLE
        $MyFGTUrl = Get-FGTWebfilterUrlfilter -name MyFGTUrl
        PS C:\>$MyFGTUrl | Set-FGTWebfilterUrlfilter -url_id 15 -url_type simple -url powerfgt.com -action allow -status enable

        Add a new URL to the MyFGTUrl profil for the url powerfgt.com

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        #[ValidateScript({ Confirm-FGTWebfilterUrlfilter $_ })]
        [psobject]$urlfilter,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 63)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0, 4294967295)]
        [string]$url_id,
        [Parameter (Mandatory = $false)]
        [ValidateSet("simple","regex","wildcard")]
        [string]$url_type,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 511)]
        [string]$url,
        [Parameter (Mandatory = $false)]
        [ValidateSet("block","allow","monitor")]
        [string]$action,
        [Parameter (Mandatory = $false)]
        [ValidateSet("enable","disable")]
        [string]$status,
        [Parameter (Mandatory = $false)]
        [ValidateSet("av","web-content","activex-java-cookie","dlp","fortiguard","range-block","pass","antiphish","all")]
        [string]$exempt,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter (Mandatory = $false)]
        [String[]]$vdom,
        [Parameter (Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/webfilter/urlfilter/$($urlfilter.id)"

        $_urlfilter = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_urlfilter | add-member -name "name" -membertype NoteProperty -Value $name
            $urlfilter.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_urlfilter | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        $_entry = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('url_id') ) {
            $_entry | add-member -name "id" -membertype NoteProperty -Value $url_id
        }

        if ( $PsBoundParameters.ContainsKey('url_type') ) {
            $_entry | add-member -name "type" -membertype NoteProperty -Value $url_type
        }

        if ( $PsBoundParameters.ContainsKey('url') ) {
            $_entry | add-member -name "url" -membertype NoteProperty -Value $url
        }

        if ( $PsBoundParameters.ContainsKey('action') ) {
            $_entry | add-member -name "action" -membertype NoteProperty -Value $action
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            $_entry | add-member -name "status" -membertype NoteProperty -Value $status
        }

        if ( $PsBoundParameters.ContainsKey('exempt') ) {
            $_entry | add-member -name "exempt" -membertype NoteProperty -Value $exempt
        }

        $urlfilter.entries += $_entry

        $_urlfilter | add-member -name "entries" -membertype NoteProperty -Value $urlfilter.entries

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $_urlfilter | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_urlfilter | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ($PSCmdlet.ShouldProcess($urlfilter.name, 'Configure URL FIlter entry')) {
            Invoke-FGTRestMethod -method "PUT" -body $_urlfilter -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTWebfilterUrlfilter -connection $connection @invokeParams -name $urlfilter.name
        }
    }

    End {
    }
}

function Remove-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Remove a FortiGate Webfilter URLFilter

        .DESCRIPTION
        Remove a FortiGate Webfilter URLFilter object on the FortiGate

        .EXAMPLE
        $MyFGTURL = Get-FGTWebfilterUrlfilter -name MyFGTURL
        PS C:\>$MyFGTURL | Remove-FGTWebfilterUrlfilter

        Remove Webfilter URLFilter object $MyFGTURL

        .EXAMPLE
        $MyFGTURL = Get-FGTWebfilterUrlfilter -name MyFGTURL
        PS C:\>$MyFGTURL | Remove-FGTWebfilterUrlfilter -confirm:$false

        Remove Webfilter URLFilter object $MyFGTURL with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        #[ValidateScript({ Confirm-FGTWebfilterUrlfilter $_ })]
        [psobject]$url,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/webfilter/urlfilter/$($url.id)"

        if ($PSCmdlet.ShouldProcess($url.name, 'Remove WebFilter UrlFilter')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}