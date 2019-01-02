# Site-to-Site VPN to Azure

## Vocabulary

### Policy based vs. route based VPN gateway

[About policy-based and route-based VPN gateways (Microsoft docs)](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-connect-multiple-policybased-rm-ps#abaut)

Policy based VPN gateway (Image by Microsoft)
![policy based gw](https://docs.microsoft.com/en-us/azure/vpn-gateway/media/vpn-gateway-connect-multiple-policybased-rm-ps/policybasedmultisite.png)

Route bases VPN gateway (Image by Microsoft)
![route based gw](https://docs.microsoft.com/en-us/azure/vpn-gateway/media/vpn-gateway-connect-multiple-policybased-rm-ps/routebasedmultisite.png)

## Lab

### Scenario

![Scenario]()
### Set Variables in Bash

```bash
Location="westeurope"
RGroup="ContosoRG"
VNet="ContosoVNet"
AddressPrefixes="172.18.0.0/16"
FirstSubnetName="Deployment"
FirstSubnetPrefix="172.18.0.0/24"
VngSubnetPrefix="172.18.255.240/28"
VngName="ContosoVNG"
VngPip="$VngName-Pip"
P2SClientAddressPrefix="192.168.0.0/24"
LngName="NaLNG"
LngPip="79.218.143.26"
LnGAddressPrefix="192.168.42.0/24"
VpnName="NA-Contoso-VPN"
VpnKey='%0anbdabK=Fdce2f0d414a6!c1a4b1fk'
```

### Create Resource Group (RG)

[Create a new resource group](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create)

```bash
az group create --name $RGroup --location $Location

az group list -o table
```

### Create Virtual Network (VNet)

[Create a virtual network](https://docs.microsoft.com/en-us/cli/azure/network/vnet?view=azure-cli-latest#az-network-vnet-create)

```bash
az network vnet create --name $VNet \
                       --location $Location \
                       --resource-group $RGroup \
                       --address-prefixes $AddressPrefixes \
                       --subnet-name $FirstSubnetName \
                       --subnet-prefix $FirstSubnetPrefix

az network vnet list -o table
```

### Create Subnet "GatewaySubnet"

[Create a subnet](https://docs.microsoft.com/en-us/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-create)

```bash
az network vnet subnet create --name GatewaySubnet \
                              --address-prefix $VngSubnetPrefix \
                              --vnet-name $VNet \
                              --resource-group $RGroup

az network vnet subnet list --resource-group $RGroup --vnet-name $VNet -o table
```

### Create Public IP (PIP)

[Create a public IP address](https://docs.microsoft.com/en-us/cli/azure/network/public-ip?view=azure-cli-latest#az-network-public-ip-create)

```bash
az network public-ip create --name $VngPip \
                            --resource-group $RGroup \
                            --allocation-method dynamic \
                            --location $Location

az network public-ip list -o table --resource-group $RGroup
```

### Create Virtual Network Gateway (VNG)

[Create a virtual network gateway](https://docs.microsoft.com/en-us/cli/azure/network/vnet-gateway?view=azure-cli-latest#az-network-vnet-gateway-create)

```bash
az network vnet-gateway create --name $VngName \
                               --location $Location \
                               --resource-group $RGroup \
                               --vnet $VNet \
                               --address-prefixes $P2SClientAddressPrefix \
                               --public-ip-addresses $VngPip \
                               --vpn-type PolicyBased \
                               --sku Basic \
                               --no-wait

az network vnet-gateway list --resource-group $RGroup -o table
```

### Create Local Network Gateway (LNG)

[Create a local VPN gateway](https://docs.microsoft.com/en-us/cli/azure/network/local-gateway?view=azure-cli-latest#az-network-local-gateway-create)

```bash
az network local-gateway create --name $LngName \
                                --location $Location \
                                --resource-group $RGroup \
                                --gateway-ip-address $LngPip \
                                --local-address-prefix $LnGAddressPrefix \
                                --no-wait

az network local-gateway list --resource-group $RGroup -o table
```

### Create Connection

[Create a VPN connection](https://docs.microsoft.com/en-us/cli/azure/network/vpn-connection?view=azure-cli-latest#az-network-vpn-connection-create)

```bash
az network vpn-connection create --name $VpnName \
                                 --location $Location \
                                 --resource-group $RGroup \
                                 --vnet-gateway1 $VngName \
                                 --local-gateway2 $LngName \
                                 --shared-key $VpnKey

az network vpn-connection list --resource-group $RGroup -o table
```

## On Prem Gateway - Example: Fritz!Box

Bjoern Olausson: [Site-to-Site VPN with Fritz!Box](https://olausson.de/news/9-news/23-azure-fritz-box-site-to-site-vpn-connetion)

```cfg
vpncfg {
        connections {
                enabled = yes;
                conn_type = conntype_lan;
                name = "HeidelbergGW";
                always_renew = no;
                reject_not_encrypted = no;
                dont_filter_netbios = yes;
                localip = 0.0.0.0;
                local_virtualip = 0.0.0.0;
                remoteip = 23.97.252.224;
                remote_virtualip = 0.0.0.0;
                localid {
                        fqdn = "nielsabel.ddns.net";
                }
                remoteid {
                        ipaddr = 23.97.252.224;
                }
                mode = phase1_mode_aggressive;
                phase1ss = "all/all/all";
                keytype = connkeytype_pre_shared;
                key = "%0anbdabK=Fdce2f0d414a6!c1a4b1fk";
                cert_do_server_auth = no;
                use_nat_t = yes;
                use_xauth = no;
                use_cfgmode = no;
                phase2localid {
                        ipnet {
                                ipaddr = 192.168.42.0;
                                mask = 255.255.255.0;
                        }
                }
                phase2remoteid {
                        ipnet {
                                ipaddr = 172.17.0.0;
                                mask = 255.255.0.0;
                        }
                }
                phase2ss = "esp-all-all/ah-none/comp-all/no-pfs";
                accesslist = "permit ip any 172.17.0.0 255.255.0.0";
        }
        ike_forward_rules = "udp 0.0.0.0:500 0.0.0.0:500", 
                            "udp 0.0.0.0:4500 0.0.0.0:4500";
}
```

### Update Public IP Address (LNG)

```bash
az network local-gateway update --name $LngName \
                                --resource-group $RGroup \
                                --gateway-ip-address `host -4 nielsabel.ddns.net  | awk '/has address/{print $4}'`
```