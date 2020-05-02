# Point-to-Site VPN: Supplement to Microsoft Learning Course AZ-300

This Lab is a supplement to Microsoft Learning courses [AZ-300T02](https://docs.microsoft.com/en-us/learn/certifications/courses/az-300t02) (Module 3).

This Lab adds a Point-to-Site VPN to the network infrastructure build by AZ-300 Module 3's Lab [Configuring VNet peering and service chaining](https://github.com/MicrosoftLearning/AZ-300-MicrosoftAzureArchitectTechnologies/blob/master/Instructions/AZ-300T02_Lab_Mod03_Configuring%20VNet%20peering%20and%20service%20chaining.md).

## Existing Network Infrastructure

Hub-Vnet, Spoke-Vnet, Peering

Route table, Custom Route

VM1, VM2, VM3

## Supplemental Network Infrastructure

Gateway, PC

## Overview
There are five exercises in this Lab:

| | |
|-|-|
| Exercise 1 | Define variables
| Exercise 2 | Verify existing infrastructure
| Exercise 3 | Create virtual gateway
| Exersise 4 | Add VPN to PC and test
| Exersise 5 | Clean up

Most tasks are written in Azure CLI. Few tasks in exercise 3 use PowerShell cmdlets. **In principal PowerShell is required as Shell**, either CloudShell or local PowerShell. Azure CLI version 2.5.0 or above is required.

## Exercise 1: Define variables

```powershell
```

## Exercise 2: Verify existing infrastructure
### Task 1: Verify hub and spoke virtual networks
### Task 2: Verify virtual machines
### Task 3: Verify peering
### Task 4: Verify custom route


## Exercise 3: Create virtual gateway
### Task 1: Create gateway subnet
### Task 2: Create gateway public ip
### Task 3: Create gateway
### Task 4: Configure *Allow gateway transit* on hub
[docs](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-peering-gateway-transit)

### Task 5: Configure *Use remote gateway* on spoke
### Task 6: Configure *Virtual network gateway route propagation*
Warum? Damit man von von VM3 aus den PC anpingen kann (ping 192.168.0.2).
[docs](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes)

### Task 7: Create root and client certificates
### Task 8: Copy root certificate to gateway configuration



## Exercise 4: Add VPN to PC and Test
### Task 1: Download and install VPN client on PC
### Task 2: Test VPN connection
### Task 3. Dissociate public IP addresses
Public IP addresses of VMs are not needed any more.



## Exersise 5: Clean up
### Task 1: Remove Azure resources
### Task 2: Remove VPN aon PC