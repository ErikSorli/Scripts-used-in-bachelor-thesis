param(
    [string]$loc,
    [string]$ClientType
)

#Concat type and location 
$SiteCode = $ClientType + "-" + $loc

# Find and count all computers in AD with that site code. 
# Increment by one and rename
$computers = get-adcomputer -Server <DC> -filter "name -like '$SiteCode*' "
[int]$count = $($computers | measure).Count
$count++
$hostname = $SiteCode + "-" + $count
Rename-Computer -NewName $hostname -force

