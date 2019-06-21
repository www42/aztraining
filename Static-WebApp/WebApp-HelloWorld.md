# Lab: WebApp-Static

## Lab Scenario

Create a static HTML WebApp. Deployment is done super simply by running a two parameter az command:

```bash
az webapp run --name foo --location westeurope
```

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az account list -o table
```

### Set variables

```bash
Location="westeurope"
App_Name="<specify your webapp name>"
```

### Add an Az Cli extension

Syntax: [Add an extension](https://docs.microsoft.com/de-de/cli/azure/extension?view=azure-cli-latest#az-extension-add)

```bash
az extension list-available -o table
az extension add --name webapp
az extension list -o table
```

### Create static HTML file

```bash
code
```

Type in your html code!

```html
<html>
  <body>
    <h1>Hello World!</h1>
  </body>
</html>
```

Save file as index.html!

```bash
mkdir ~/webapp
mv index.html webapp/
cd ~/webapp
ls -l
```

### Create and deploy WebApp

Syntax: [Create and deploy existing local code to the WebApp](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-up)

```bash
az webapp up --location $Location --name $App_Name
```

### Browse the WebApp

Start your favourite web browser at

```bash
<specify your webapp name>.azurewebsites.net
```

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
