# Sikre UTF-8-støtte
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Informere brukeren om konsekvensene
Write-Host "Warning: This process will reinstall the system and erase ALL contents of the hard drive!" -ForegroundColor Red
Write-Host "Do you want to continue? Press 'Y' for Yes or 'N' for No" -ForegroundColor Yellow

# Spør brukeren om bekreftelse
$svaret = Read-Host "Your choice"

# Kontrollere brukerens svar
if ($svaret -eq 'Y') {
    Write-Host "Startar OSDCloud-processen... The system will install and delete all data on the hard drive!" -ForegroundColor Green
    Start-OSDCloud -ImageFileUrl https://managementosdcloudst.blob.core.windows.net/osd/Win_LTSC_2021_SV.wim -ImageIndex 1 -ZTI
    Write-Host -ForegroundColor Green "Restarting in 10 seconds!"

    Start-Sleep -Seconds 10

wpeutil reboot
} elseif ($svaret -eq 'N') {
    Write-Host "The operation was canceled by the user. No change was made." -ForegroundColor Yellow
    Write-Host -ForegroundColor Green "Restarting in 20 seconds!"

    Start-Sleep -Seconds 20

wpeutil reboot
} else {
    Write-Host "Invalid selection. Please run the script again and select 'Y' eller 'N'." -ForegroundColor Red
}
