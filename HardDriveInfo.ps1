param (
    [string]$CompName=(Read-Host "Enter the computer name:"),
    [string]$AlternateCreds

)

If($AlternateCreds -eq $true) 
{
    $cred= Get-Credential

    $session= New-CimSession -ComputerName $CompName -Credential $cred
    Get-CimInstance Win32LogicalDisk -CimSession $session -filter "DriveType=3"
}
Else
{
Get-CimInstance Win32_LogicalDisk -ComputerName $CompName -Filter "DriveType=3"
}

