$AutopilotParams = @{
    Online = $true
    TenantId = '06bb15dc-3bc6-406d-b397-4f7fdd149de1'
    AppId = '94c9ae95-81f8-45fd-976b-1de5e9aa8b08'
    AppSecret = 'gpH8Q~GqCnjs0BZQj-jNPDFsN8FxDTNwcAeZzbH7'
    GroupTag = 'GG'
    Assign = $true
}
start "Get-WindowsAutoPilotInfo" PowerShell -NoL -C Get-WindowsAutoPilotInfo @AutopilotParams
