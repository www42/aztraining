# Lab: WebApp-Static

## Lab Scenario

Create a static HTML WebApp. Static HTML code is copied from a GitHub repo. Deployment is done super simply by running a two parameter az command:

```bash
az webapp run --name foo --location westeurope
```

## This Lab ist stolen from

Microsoft docs: [Create a static HTML web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-html).

## Lego Building Blocks

* [Azure App Service - Overview](https://azure.microsoft.com/en-us/resources/videos/azure-app-service-overview/)
* [Az Cli extensions](https://github.com/Azure/azure-cli/tree/master/doc/extensions)
* [GitHub repos](https://help.github.com/articles/cloning-a-repository/)

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az account list -o table
```

### Set variables

```bash
Location="westeurope"
App_Name="viking"
```

### Add an Az Cli extension

Syntax: [Add an extension](https://docs.microsoft.com/de-de/cli/azure/extension?view=azure-cli-latest#az-extension-add)

```bash
az extension list-available -o table
az extension add --name webapp
az extension list -o table
az extension show --name webapp
```

### Copy static HTML files from GitHub repo

```bash
mkdir ~/git
cd ~/git
git clone https://github.com/Azure-Samples/html-docs-hello-world.git
ls -l
```

### Create and deploy WebApp

Syntax: [Create and deploy existing local code to the WebApp](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-up)

```bash
cd html-docs-hello-world
az webapp up --location $Location --name $App_Name
```

### Browse the WebApp

### Discover the WebApp

```bash
az webapp list -o table
az webapp list -o json --query '[0].resourceGroup'
RGroup=$(az webapp list -o json --query '[0].resourceGroup' | tr -d '"')
az webapp show --name $App_Name --resource-group $RGroup
```

### Make some changes to and redeploy WebApp

```bash
vi index.html
az webapp up --location $Location --name $App_Name
```

### Remove WebApp by removing resource group

Syntax: [Delete a resource group](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-delete)

```bash
az group delete --name $RGroup --yes --no-wait
az group list -o table
```
