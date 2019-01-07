#https://stackoverflow.com/questions/41281112/crontab-not-working-with-bash-on-ubuntu-on-windows
#bash -c "pwd"
Write-Host -foregroundcolor Yellow "FritzBox 7490 WiFi actual state:"
$out = bash -c "~/fritzBoxShell.sh WLAN STATE"
foreach ($item in $out) {
    Write-Host -foregroundcolor Blue -object $item
}
Write-Host -foregroundcolor Magenta "Do you want the Wifi On or Off?"
$value = Read-Host "1 or 0" 

$out = bash -c "~/fritzBoxShell.sh WLAN $value"
foreach ($item in $out) {
    Write-Host -foregroundcolor Blue -object $item
}
#bash -c "~/fritzBoxShell.sh WLAN 0"