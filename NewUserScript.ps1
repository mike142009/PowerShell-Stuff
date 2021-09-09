[CmdletBinding()]
param
(
[Parameter(Mandatory)]
[ValidateNotNullorEmpty()]
[string]$FirstName,


[Parameter(Mandatory)]
[ValidateNotNullorEmpty()]
[string]$LastName,

[Parameter(Mandatory)]
[ValidateNotNullorEmpty()]
[string]$Department




)

try{
$username =  ($FirstName + " " + $LastName)



$NextOneUp =2
while (Get-ADUser -Filter "samAccountName -eq '$firstname'")
    {

    Write-Warning -Message "The username [$($username)] already exist. Will try again.."
    $username =  $FirstName.Substring(0,$NextOneUp)
    Start-Sleep -Seconds 1
    $nextoneup++

    }




if ($username -like "$FirstName  $LastName")
{
    throw "No avaliable username could not be found."
}


elseif(-not ($ou = Get-ADOrganizationalUnit -Filter "Name -eq '$Department'"))
{
    throw "The Active Directory OU for the department [$($Department)] could not be found."
}

elseif(-not (Get-ADGroup -Filter "Name -eq '$Department'"))
{
    throw "The group [$($Department)] does not exist."
}



else{

    Add-Type -AssemblyName 'System.Web'
    $password = [System.Web.Security.Membership]::GeneratePassword(
    (Get-Random -Minimum 10 -Maximum 20), 3)
    $secretPassword = ConvertTo-SecureString -string $password -AsPlainText -Force

$NewUserParams = @{
    GivenName = $FirstName
    Surname = $LastName
    Name = $username
    AccountPassword = $secretPassword
    ChangePasswordAtLogon = $true
    Enabled = $true
    Department = $Department
    Path = $ou.DistinguishedName
    Confirm = $false
}


If($PSCmdlet.ShouldProcess("AD user [$username]", "Create AD user $FirstName $LastName"))
{
    New-ADUser @newUserParams

    Add-ADGroupMember -Identity $Department -Members $username

    [pscustomobject]@{
            FirstName = $FirstName
            LastName = $LastName
            Department= $Department      
            Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secretPassword))
            Username = $username
  }
  
  }
  
  }
  }
  
  Catch
  {
  
    Write-Error -Message $_.Exception.Message
    
    }
         
