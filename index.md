---
layout: page
lab:
    title: 'Inspect Jenkins Pipeline and Azure Resources'
---

# Lab: Inspect the Jenkins Pipeline

## Lab scenario

This lab is a follow up to a **Microsoft Learning Course Exercise**. You must have completed the Microsoft Learning Course Exercise. Otherwise this lab is useless.

The Microsoft Learning Course Exercise has the title _Implement DevOps with AKS_. It is exercise 4 of [AZ-301T03 Module 2 Lab](https://github.com/MicrosoftLearning/AZ-301-MicrosoftAzureArchitectDesign/blob/master/Instructions/AZ-301T03_Lab_Mod02_Deploying%20Managed%20Containerized%20Workloads%20to%20Azure.md#exercise-4-implement-devops-with-aks). 

## Objectives

After you complete this lab, you will 

- undestand the Jenkins pipeline. 

- understand the Grafana - Azure Monitor connection. 

- understand the Azure Container Registry used by the pipeline.

## Lab Setup

  - **Estimated Time**: 30 minutes

## Instructions

### Exercise 1: Review th Azure deployment

### Exercise 2: Inspect the Jenkins Pipeline

#### Task 1: Connect to Jenkins dashboard

1. In the Azure portal, open the CloudShell pane, start Bash.

1. Get the AppID of the Kubernetes cluster

```bash
RESOURCE_GROUP='AADesignLab0403-RG'
LOCATION='<Azure region>'
APP_ID=$(az ad sp list --all --query "[?appDisplayName=='AADesignLab0403-SP'].[appId]" --output tsv)
```

    > **Note**: Replace the `<Azure region>` placeholder with the name of the Azure region you used in the Microsoft Learning Course Exercise.

#### Task 2: Inspect Jenkins pipeline
