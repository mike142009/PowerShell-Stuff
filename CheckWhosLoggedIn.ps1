#Working on a script to see who is logged into a computer


function Get-LoggedIn  {
    
    [CmdletBinding()]
    param (
            
            [Parameter (Mandatory=$true)]
            [string[]] $ComputerName
        )

        foreach ($pc in $ComputerName) {
                $logged_in = (gwmi win32_computersystem -ComputerName $pc).username
                $name = $logged_in.split("\")[1]
                "{0}: {1}" -f $pc,$name

                }

        }