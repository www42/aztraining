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