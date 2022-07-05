<# -----------------------------------------------------
This function should kill all the open java and tomcat processes need to test with input variable.  
https://theitbros.com/run-powershell-script-on-remote-computer/

TODO using env variables sometimes I have to redeclare the variable so its a string
to clean it up might need to see if there is a powershell .toString() method
--------------------------------------------------------#>
function killWindowsService{
Param($serviceName)

	#Stop the windows service
	get-service | Where-Object {$_.Name -like $serviceName} | Stop-Service -Force
	#Stop-Service -Name "Tomcat8" -Force
	#Make sure the service is really dead
	get-process | Where-Object {$_.Name -like $serviceName} | Stop-Process -Force 
	#Stop-Process -Name "Tomcat8"
    echo "all done stoping service:" $serviceName
}

#I have to have this as a parm because the function will not read it when called
$serviceName = "$env:WINDOWSSERVICE_NAME"
#all the values except the password work without a new value but for some reason securestring pukes on it about every 3rd time
$gitHubUserPassword = "$env:SERVICE_PASSWORD"
$pw = convertto-securestring -AsPlainText -Force -String $gitHubUserPassword
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$env:SERVICE_ACCOUNT" ,$pw

#As we have a cluster of servers this should allow us to have one step kill on each box make sure you add comma after each box
$servers = "$env:SERVER_NAMES"
$serversArray =$servers.Split(",")

$i=0
while ($i -lt $serversArray.Count)
 {
  $serverName = $serversArray[$i]
  echo $serverName
  Invoke-Command  -ScriptBlock ${Function:killWindowsService} -ArgumentList $serviceName -credential $cred -ComputerName $serverName
  $i++
 }
 exit [System.Environment]::ExitCode
 




