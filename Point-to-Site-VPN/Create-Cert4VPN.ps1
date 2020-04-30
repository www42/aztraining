# Create Certificate for Point-To-Site VPN
# ----------------------------------------

$rootCert = New-SelfSignedCertificate `
              -Type Custom `
              -KeySpec Signature `
              -Subject 'CN=AdatumRootCertificate' `
              -KeyExportPolicy Exportable `
              -HashAlgorithm sha256 `
              -KeyLength 2048 `
              -CertStoreLocation 'Cert:\CurrentUser\My' `
              -KeyUsageProperty Sign `
              -KeyUsage CertSign `
              -FriendlyName 'AdatumRootCertificate'

[System.Convert]::ToBase64String($rootCert.RawData) | clip

# paste it into browser "Public certificate data"

# = = = Alternative: Azure CLI =  = = = = = = = = = = = = = = = = = = = = = = =
#                                                                             #
$RootCertPublicData=[System.Convert]::ToBase64String($rootCert.RawData)
$RootCertName="AdatumRoot"
$GatewayName="AdatumGateway"
$Hub_Group="az1000401-RG"
$ProcessorArchitecture = "Amd64"

az network vnet-gateway root-cert create --gateway-name $GatewayName --name $RootCertName --resource-group $Hub_Group --public-cert-data $RootCertPublicData
#                                                                             #
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =


$ClientCert = New-SelfSignedCertificate `
-Type Custom `
-KeySpec Signature `
-Subject 'CN=AdatumClientCertificate' `
-KeyExportPolicy Exportable `
-HashAlgorithm sha256 `
-KeyLength 2048 `
-CertStoreLocation 'Cert:\CurrentUser\My' `
-Signer $rootCert `
-TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2") `
-FriendlyName 'AdatumClientCertificate'

Get-ChildItem Cert:\CurrentUser\My | where Subject -like "CN=Adatum*" | ft Subject, Issuer, Thumbprint

az network vnet-gateway vpn-client generate --resource-group $Hub_Group --name $GatewayName --processor-architecture $ProcessorArchitecture

# Why  '-o tsv' ? Because double quotes are not allowed in Invoke-RestMethod -Uri  
$Uri = az network vnet-gateway vpn-client show-url --resource-group $Hub_Group --name $GatewayName -o tsv

Invoke-RestMethod -Uri $Uri -OutFile c:\temp\VpNClient.zip
Expand-Archive -Path c:\temp\VpnClient.zip -DestinationPath c:\temp\VpnClient
& C:\temp\VpnClient\WindowsAmd64\VpnClientSetupAmd64.exe
& ncpa.cpl

Test-Netconnection 10.104.0.4
Test-Netconnection 10.104.1.4
Test-Netconnection 10.204.0.4
Test-Netconnection 10.204.0.4 -TraceRoute


dir c:\temp


# Cleanup
Remove-Item $ClientCert.PSPath
Remove-Item $RootCert.PSPath

# VPN entfernen und deinstallieren