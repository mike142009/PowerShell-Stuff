#-----------------------------------------------------
# Starts a service on a server
#
#-----------------------------------------------------

$Servers = Get-Content C:\Users\Administrator.ADATUM\Desktop\SER.txt

Invoke-Command -ComputerName $Servers -ScriptBlock  {

                If ((Get-Service -Name BITS).Status -ne "Running") {
                #change name to start different service
                Start-Service -Name DmEnrollmentSvc

                }

        }