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


New-SelfSignedCertificate `
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

Get-ChildItem Cert:\CurrentUser\My

# Cleanup - to do
Remove-Item Cert:\CurrentUser\my\A90B8A57C2A61AB3591E0860C65637199166FE81
Remove-Item Cert:\CurrentUser\my\90C7E3425208073D2725AD984695883435942571

# VPN entfernen und deinstallieren