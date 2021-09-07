<# Finds the password of all AD users that have set there password
 in the last 30 days
#>


Get-ADUser -Filter * -Properties passwordlastset | select name,passwordlastset
$today= Get-Date
$30DaysAgo= $today.AddDays(-30)
Get-ADUser -filter "passwordlastset -lt '$30daysago'"