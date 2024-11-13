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
$ImageFileUrl = "https://managementosdcloudst.blob.core.windows.net/osd/Win_LTSC_2021_SV.esd"

Write-Host -ForegroundColor Green "Start GG POS Installasjon"

#$command = Read-Host "Please make a choice between 1-4:



Write-Host "============== GG POS Installasjon ===============" -ForegroundColor Yellow
Write-Host "ImageFileURL = $ImageFileUrl" -ForegroundColor Green

Write-Host "`n ANSVARSFRISKRIVNING: ANVÄNDNING PÅ EGEN RISK - Om du går längre kommer all data på din disk att raderas! `n"-ForegroundColor Red

#Prompt for confirmation
$title    = 'Varning'
$question = 'Är du säker på att du vill fortsätta? All data kommer att raderas och ett nytt OS kommer att installeras'
$choices  = '&Ja', '&Inga'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host 'Operation confirmed by user: Installationen startar' -ForegroundColor Yellow
} else {
    Write-Host 'Åtgärden avbröts av användaren'
    exit
}

Start-OSDCloud -ImageFileUrl $ImageFileUrl -ImageIndex 1 -Zti



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
start "Start-AutopilotOOBE" PowerShell -NoL -C Start-AutopilotOOBE -Title 'GG Autopilot Registration' -Hidden AssignedUser, AssignedComputerName -GroupTag GG -GroupTagOptions GG, POS -AddToGroupOptions 'INTUNE_GG_DEVICE_WINDOWS_ALL_Backoffice' -Assign -PostAction Restart Computer

exit
'@
$SetCommand | Out-File -FilePath "C:\Windows\Autopilot.cmd" -Encoding ascii -Force



#Restart from WinPE

Write-Host -ForegroundColor Green "Restarting in 20 seconds!"

Start-Sleep -Seconds 20

wpeutil reboot
