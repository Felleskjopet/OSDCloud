$ImageFileUrl = "https://managementosdcloudst.blob.core.windows.net/osd/Win_LTSC_2021_SV.esd"

cls
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "============== GG POS Installasjon ===============" -ForegroundColor Yellow
Write-Host "==========  ==========" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow
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

#reboot to OS
wpeutil reboot
