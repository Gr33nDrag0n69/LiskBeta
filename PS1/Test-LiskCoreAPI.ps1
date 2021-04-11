
# Init. #######################################################################

$Global:ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear-Host

# Configuration ###############################################################

$Config = @{
    API = 'https://betanet-api.lisknode.io/'
    Account = @(
        'c6d076ed541ca20869a1398a9d28c645ac8a8719',
        '79d9caba60f49a39026cf69f55eb87163c1689d2',
        '2e9f8c9f3991f1bcd03a9e32a7d6316722c96eae'
        )
    Delegate = @(
        'c6d076ed541ca20869a1398a9d28c645ac8a8719',
        '87b2952e1f3594c9ea4f68589ce8793cae9a54aa'
        )
    Node = @(
        'https://beta.lisk.n0d3.io/'
        )
    PublicNode = @(
        'https://betanet-api.lisknode.io/',
        'https://betanet5.lisk.io/',
        'https://beta.lisk.n0d3.io/'
    )
}

# Function(s) #################################################################

Function Invoke-LiskApiCall {

    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $True)]
        [System.String] $URI,

        [parameter(Mandatory = $True)]
        [ValidateSet('Get','Post','Put')]
        [System.String] $Method,

        [parameter(Mandatory = $False)]
        [System.Collections.Hashtable] $Body = @{}
        )

    Write-Verbose "Invoke-LiskApiCall [$Method] => $URI"

    if( $Method -eq 'Get' ) {
        $Private:WebRequest = Invoke-WebRequest -UseBasicParsing -Uri $URI -Method $Method
    } elseif( ( $Method -eq 'Post' ) -or ( $Method -eq 'Put' ) ) {
        $Private:WebRequest = Invoke-WebRequest -UseBasicParsing -Uri $URI -Method $Method -Body $Body
    }

    if( ( $WebRequest.StatusCode -eq 200 ) -and ( $WebRequest.StatusDescription -eq 'OK' ) ) {
        $WebRequest.Content | ConvertFrom-Json | Select-Object -ExpandProperty Data
    } else {
        Write-Warning "Invoke-LiskApiCall | WebRequest returned Status '$($WebRequest.StatusCode) $($WebRequest.StatusDescription)'."
    }
}

# Main ########################################################################

## Account

$AccountList = @()

ForEach( $AccountBinaryAddress in $Config.Account ) {

    $Account = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/accounts/'+$AccountBinaryAddress )
    
    $AvailableBalance = $Account.Token.Balance / 100000000
    $VotingBalance = $( $Account.dpos.sentVotes.amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum ) / 100000000

    $AccountList += [PSCustomObject]@{
        Address = $AccountBinaryAddress
        AvailableBalance = $AvailableBalance
        VotingBalance = $VotingBalance
        TotalBalance = $AvailableBalance + $VotingBalance
    }
}

Write-Host '# Account'
$AccountList | Format-Table

## Delegate

$DelegateList = @()

ForEach( $AccountBinaryAddress in $Config.Delegate ) {

    $Account = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/accounts/'+$AccountBinaryAddress )

    $DelegateList += [PSCustomObject]@{
        Name = $Account.dpos.delegate.username
        TotalVote = $Account.dpos.delegate.totalVotesReceived / 100000000
        ConsecutiveMissedBlocks = $Account.dpos.delegate.consecutiveMissedBlocks
        LastForgedHeight = $Account.dpos.delegate.lastForgedHeight
    
    }
}

Write-Host '# Delegate'
$DelegateList | Format-Table

## Node

$NodeList = @()

ForEach( $NodeUrl in $Config.Node ) {

    $Node = Invoke-LiskApiCall -Method Get -URI $( $NodeUrl + 'api/node/info' )

    $NodeList += $Node | Select-Object -Property Version, NetworkVersion, Height, FinalizedHeight, Syncing, UnconfirmedTransactions
}

Write-Host '# Node'
$NodeList | Format-Table

## Public Node

$NodeList = @()

ForEach( $NodeUrl in $Config.PublicNode ) {

    $Node = Invoke-LiskApiCall -Method Get -URI $( $NodeUrl + 'api/node/info' )

    $NodeList += $Node | Select-Object -Property Version, NetworkVersion, Height, FinalizedHeight, Syncing, UnconfirmedTransactions
}

Write-Host '# Public Node'
$NodeList | Format-Table

## Peers

$PeerList = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/peers' )

$TopHeight = $PeerList.options.height | Sort-Object -Unique -Descending | Select-Object -First 1

Write-Host "PeerList TopHeight: $TopHeight"

#$PeerList | FT
#$PeerList.options | FT




#-----------------------------------
<#
$ForgingInfo = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/forging/info' )

$DelegateList = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/delegates' )
$ForgerList = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/forgers' )


Write-Host ''
Write-Host 'ForgingInfo'
$ForgingInfo | FL *

Write-Host ''
Write-Host 'DelegateList'
$DelegateList | Select-Object -First 1 | FL *

Write-Host ''
Write-Host 'ForgerList - Gr33nDrag0n Data'
$ForgerList | Where-Object { $_.username -eq $DelegateName } | FL *

#>