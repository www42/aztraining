# Lab: Send events from private container registry to Event Grid

This Lab is from [Microsoft Docs](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-event-grid-quickstart).

```bash
RESOURCE_GROUP_NAME="EventGrid-RG"
az group create --name $RESOURCE_GROUP_NAME --location westeurope
```

Container registry
```bash
ACR_NAME="acr69118"
az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Basic
az acr list -o table
```

Event endpoint (consuming app)
```bash
SITE_NAME="website69118"
az group deployment create \
    --resource-group $RESOURCE_GROUP_NAME \
    --template-uri "https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/master/azuredeploy.json" \
    --parameters siteName=$SITE_NAME hostingPlanName=$SITE_NAME-plan

```
Visit https://website69118.azurewebsites.net

Event Grid resource provider
```bash
az provider show --namespace Microsoft.EventGrid --query "registrationState"
az provider register --namespace Microsoft.EventGrid
```

Event Grid Subscription
```bash
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)
APP_ENDPOINT=https://$SITE_NAME.azurewebsites.net/api/updates

az eventgrid event-subscription list --location westeurope 
az eventgrid event-subscription show --name event-sub-acr --resource-group $RESOURCE_GROUP_NAME

az eventgrid event-subscription create \
    --name event-sub-acr \
    --source-resource-id $ACR_REGISTRY_ID \
    --endpoint $APP_ENDPOINT
```
Das hat folgendes erzeugt:
* Event Grid Subscription (aber keine Event Grid Domain, es wird so was wie 'Domain System' verwendet)
* Event Grid System Topic (aber kein  Event Grid Topic)

```bash
az eventgrid event-subscription list --location westeurope --query "[].{name:name,topic:topic}"
az eventgrid event-subscription show --name event-sub-acr --source-resource-id $ACR_REGISTRY_ID 
```

Was ist eigentlich ein Topic?
```bash
az eventgrid topic-type list --query "[].displayName"
```

ACR Task to build an image and upload to ACR
```bash
az acr build --registry $ACR_NAME --image myimage:v1 -f Dockerfile https://github.com/Azure-Samples/acr-build-helloworld-node.git
az acr repository show-tags --name $ACR_NAME --repository myimage
```

Delete Image
```bash
az acr repository delete --name $ACR_NAME --image myimage:v1 --yes
```

## Clean up
```bash
az group delete --name $RESOURCE_GROUP_NAME --yes
```