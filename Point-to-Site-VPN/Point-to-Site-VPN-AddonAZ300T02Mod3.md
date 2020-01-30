# Lab: Point-To-Site VPN

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az account list -o table
```

### Some Variables

```bash

```


### Create Subnet "GatewaySubnet"

```bash

```

### Create Public IP (PIP)

```bash

```

### Create Virtual Network Gateway (VNG)

```bash

```

### Wait for ProvisioningState "Succeeded"

### Create Certificate for Point-to-Site VPN

Switch to local (Windows 10) PowerShell

```Powershell
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
```

Paste it into browser (Azure Portal) "Public certificate data".

![Azure Portal](img/RootCert-AzureGW.png)

```Powershell
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
```

### Download VPN Client

### Test the VPN
Get-NetIPConfiguration | where InterfaceAlias -eq az3000401-vnet
Test-NetConnection 10.0.0.4 -Traceroute
Test-NetConnection 10.0.1.4 -Traceroute
Test-NetConnection 10.0.4.4 -Traceroute