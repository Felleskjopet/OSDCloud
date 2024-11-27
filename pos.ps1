# Sikre UTF-8-støtte
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Informere brukeren om konsekvensene
Write-Host "⚠️ Varning: Denna process kommer att reinstallera systemet och radera ALLT innehåll på hårddisken!" -ForegroundColor Red
Write-Host "Vill du fortsätta? Tryck 'J' för Ja eller 'N' för Nej." -ForegroundColor Yellow

# Spør brukeren om bekreftelse
$svaret = Read-Host "Ditt val"

# Kontrollere brukerens svar
if ($svaret -eq 'J') {
    Write-Host "Startar OSDCloud-processen... Systemet kommer att reinstallera och radera all data på hårddisken!" -ForegroundColor Green
    Start-OSDCloud -ImageFileUrl https://managementosdcloudst.blob.core.windows.net/osd/Win_LTSC_2021_SV.wim -ZTI
    Write-Host -ForegroundColor Green "Restarting in 10 seconds!"

    Start-Sleep -Seconds 10

wpeutil reboot
} elseif ($svaret -eq 'N') {
    Write-Host "Operationen avbröts av användaren. Ingen ändring gjordes." -ForegroundColor Yellow
    Write-Host -ForegroundColor Green "Restarting in 20 seconds!"

    Start-Sleep -Seconds 20

wpeutil reboot
} else {
    Write-Host "Ogiltigt val. Vänligen kör skriptet igen och välj 'J' eller 'N'." -ForegroundColor Red
}
