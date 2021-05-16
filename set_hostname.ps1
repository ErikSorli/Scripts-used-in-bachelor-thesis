# Find Default Gateway. -InterfaceAlias might have to be changed, depending on which
# network adapter is in use.

$DG = (Get-NetIPConfiguration -InterfaceAlias Ethernet0).IPv4DefaultGateway.NextHop
# Import site codes and default gateways from the list gateways.txt 
# and find the one that matches this computers gateway.

$list = Get-Content -Path .\gateways.txt
$DGandSite = ($list -match $DG)
# Strip away the gateway

$SiteCode = ($DGandSite -Split ':' ,2)[1]
# Find and count all computers in ad with that site code. Increment by one and rename

$computers = get-adcomputer -Server <DC> -filter "name -like '$SiteCode*'"
[int]$count = $($computers | measure).Count
$count++
$hostname = "$SiteCode-$count"
Rename-Computer -NewName $hostname -force
