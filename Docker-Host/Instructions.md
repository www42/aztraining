# Lab: Docker-Host

## Scenario

Create Linux VM with Docker installed. Use ARM template from GitHub.

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az account list -o table
```

### Set Variables

Location="westeurope"
RGroup="Docker"

### Create Resource Group

```bash
az group create --name $RGroup --location $Location

az group list -o table
```

### Create VM running Docker

```bash
az group deployment create --resource-group $RGroup --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/docker-simple-on-ubuntu/azuredeploy.json
```

When prompted, type in parameter values:

```bash
adminUsername: student
adminPassword: <secure root user password>
dnsNameForPublicIp: <hostname - only lowercase letters and digits>
```

### Connect to VM via ssh

```bash
az vm list -o table

FQDN=$(az vm show --resource-group $RGroup --name MyDockerVM --show-details --query [fqdns] --output tsv)
echo $FQDN
ssh student@$FQDN
```

### Test Docker installation

```bash
docker version
```