Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"

Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine

if ((Get-MyComputerModel) -match 'Virtual') {

Write-Host -ForegroundColor Green "Setting Display Resolution to 1600x"

Set-DisRes 1600

}

#Make sure I have the latest OSD Content

#Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"

#Install-Module OSD -Force

#Write-Host -ForegroundColor Green "Importing OSD PowerShell Module"

#Import-Module OSD -Force

##Start OSDCloud ZTI the RIGHT way

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

#================================================
#  [PostOS] OOBEDeploy Configuration
#================================================
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json"
$OOBEDeployJson = @'
{
    "AddNetFX3":  {
                      "IsPresent":  false
                  },
    "Autopilot":  {
                      "IsPresent":  false
                  },
    "RemoveAppx":  [
                    "MicrosoftTeams",
                    "Microsoft.GamingApp",
                    "Microsoft.MicrosoftSolitaireCollection",
                    "microsoft.windowscommunicationsapps",
                    "Microsoft.WindowsFeedbackHub",
                    "Microsoft.Xbox.TCUI",
                    "Microsoft.XboxGameOverlay",
                    "Microsoft.XboxGamingOverlay",
                    "Microsoft.XboxIdentityProvider",
                    "Microsoft.XboxSpeechToTextOverlay",
                    "Microsoft.YourPhone",
                    "Microsoft.ZuneMusic",
                    "Microsoft.ZuneVideo"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  false
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}

$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force


#================================================
#  [PostOS] AutopilotOOBE Configuration Staging
#================================================

$SetCommand = @'
@echo off

PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Provisioning\Diagnostics\AutoPilot /va /f
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Felleskjopet/OSDCloud/main/Set-KeyboardLaguages.ps1
Start /Wait PowerShell -NoL -C Start-OOBEDeploy
start PowerShell -NoL -W Mi
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Provisioning\Diagnostics\AutoPilot /va /f
start "Install-Module AutopilotOOBE" /wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
start "Start-AutopilotOOBE" PowerShell -NoL -C Start-AutopilotOOBE -Title 'FK Autopilot Registration' -Hidden AssignedUser, AssignedComputerName -GroupTag FK -GroupTagOptions FK, POS, JSA -AddToGroupOptions 'MEM - Flog Surface' -Assign -PostAction Restart Computer

exit
'@
$SetCommand | Out-File -FilePath "C:\Windows\Autopilot.cmd" -Encoding ascii -Force


#Restart from WinPE

Write-Host -ForegroundColor Green "Restarting in 20 seconds!"

Start-Sleep -Seconds 20

wpeutil reboot
