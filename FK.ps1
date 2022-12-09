Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"

Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine

if ((Get-MyComputerModel) -match 'Virtual') {

Write-Host -ForegroundColor Green "Setting Display Resolution to 1600x"

Set-DisRes 1600

}

#Make sure I have the latest OSD Content

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"

Install-Module OSD -Force

Write-Host -ForegroundColor Green "Importing OSD PowerShell Module"

Import-Module OSD -Force

#Start OSDCloud ZTI the RIGHT way

Write-Host -ForegroundColor Green "Start OSDCloud"

$command = Read-Host "Please make a choice between 1-4:

1. Windows 11 22H2 Norsk
2. Windows 11 22H2 Engeslk
3. OSDCloud GUI
4. OSDCloud Azure

Select 1-4 and press enter

"

# Run the selected command
switch($command) {
    "1" { Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Enterprise -OSLanguage nb-no -ZTI }
    "2" { Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Enterprise -OSLanguage en-us -ZTI }
    "3" { Start-OSDCloudGUI }
    "4" { Start-OSDCloudAzure }
    default { Write-Host "Invalid selection." }
}

#Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Enterprise -OSLanguage nb-no -ZTI

#Restart from WinPE

Write-Host -ForegroundColor Green "Restarting in 20 seconds!"

Start-Sleep -Seconds 20

wpeutil reboot