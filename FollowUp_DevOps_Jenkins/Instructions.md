# Inspect Jenkins Pipeline and Azure Resources

##  Follow Up to Microsoft Learning Course AZ-301T03 Lab Mod 2 Exercise 4

## Scenario
[CI/CD pipeline for container-based workloads](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/devops-with-aks) (Azure Architecture Center)

## Variables
```bash
RESOURCE_GROUP='AADesignLab0403-RG'
LOCATION='westeurope'
APP_ID=$(az ad sp list --all --query "[?appDisplayName=='AADesignLab0403-SP'].[appId]" --output tsv)
```

A hole bunch of resource has been created by ARM template

ARM template visualizer in VS Code
```bash
az resource list --resource-group $RESOURCE_GROUP -o table
```

## Jenkins

Jenkins VM
```bash
az vm list --show-details --resource-group $RESOURCE_GROUP --output table
jenkinsFqdn=$(az vm show --show-details --name jenkins --resource-group $RESOURCE_GROUP --query "fqdns" --output tsv)
```

Connect to Jenkins dashboard via ssh tunnel
```bash
jenkinsSSH=$(az deployment group show --name azuredeploy --resource-group $RESOURCE_GROUP --query "properties.outputs.jenkinsSSH.value" --output tsv)
$jenkinsSSH
```

Get Jenkins admin password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Open in browser http://localhost:8080

Login to Jenkins dashboard with the admin password


## Azure Container Registry (ACR)

Container Registry

```bash
acrId=$(az resource list --resource-type Microsoft.ContainerRegistry/registries --resource-group $RESOURCE_GROUP --query "[].id" --output tsv)
acrName=$(az resource show --ids $acrId --query "name" --output tsv)

az acr repository list --name $acrName 
az acr repository show --name $acrName --repository hello-world 
az acr repository show --name $acrName --image hello-world:1
```


## Azure Kubernetes Service (AKS)

Connect to Kubernetes Cluster
```bash
aksName=$(az aks list --resource-group $RESOURCE_GROUP --query "[].name" --output tsv)
az aks get-credentials --name $aksName --resource-group $RESOURCE_GROUP

kubectl get deployments
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get services
```

Record the public ip of "hello-world-service", open in browser


## Grafana

```bash
grafanaUrl=$(az deployment group show --name azuredeploy --resource-group $RESOURCE_GROUP --query "properties.outputs.grafanaUrl.value" --output tsv)
echo $grafanaUrl
```

Log in to Grafana Dashboard
* user: admin    
* password: Pa55w.rd1234



## Clean up
```bash
az group delete --name $RESOURCE_GROUP --yes --no-wait

az ad sp delete --id $APP_ID

rm ~/parameters.json*
rm ~/azuredeploy.json*

ssh-keygen -R $jenkinsFqdn

kubectl config view
kubectl config delete-context $aksName
kubectl config delete-cluster $aksName
kubectl config unset users.clusterUser_AADesignLab0403-RG_$aksName
```
