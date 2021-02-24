
connect-viserver -server "vcsa.fqdn.com" -user "your-user-name" -password "your-password"


Get-VMHost | Foreach {
    #Disable the SLP firewall rule
    Get-VMHostFirewallException -VMHost $_ -Name "CIM SLP" | Set-VMHostFirewallException -Enabled:$False -verbose
    Write-Host "Disabled on " $_

    #Stopping the SLP service
    Get-VMHost -name $_ | Get-VMHostService | where {$_.key -eq 'slpd'} | Stop-VMHostService -Confirm:$false
    
    #disable automatic startup of service on reboot
    Get-VMHost -name $_ | Get-VMHostService | where {$_.key -eq 'slpd'} | Set-VMHostService -Confirm:$false -policy Off

}

disconnect-viserver -server "vcsa.fqdn.com"" -Force