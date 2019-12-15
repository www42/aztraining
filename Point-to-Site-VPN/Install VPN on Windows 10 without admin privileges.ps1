# Install a VPN connection without admin privileges

$ServerAddress = "52.157.173.180"
Add-VpnConnection -Name "Adatum VPN" `
                  -ServerAddress $ServerAddress `
                  -TunnelType "Automatic"

Get-VpnConnection
# Franz Schubert - Die Unvollendete