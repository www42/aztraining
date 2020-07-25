---
layout: page
lab:
    title: 'Inspect Jenkins Pipeline and Azure Resources'
---

# Lab: Inspect Jenkins Pipeline and Azure Resources

## Lab scenario

This is a follow up to Microsoft Learning Course [AZ-301T03 Lab Module 2 Exercise 4](https://github.com/MicrosoftLearning/AZ-301-MicrosoftAzureArchitectDesign/blob/master/Instructions/AZ-301T03_Lab_Mod02_Deploying%20Managed%20Containerized%20Workloads%20to%20Azure.md#exercise-4-implement-devops-with-aks). That Microsoft lab is labled _Implement DevOps with AKS_. It is assumed that you completed that lab.

## Objectives

After you complete this lab, you will 

- undestand the Jenkins pipeline. 

- understand the Grafana - Azure Monitor connection. 

- understand the Azure Container Registry used by the pipeline.

## Lab Setup

  - **Estimated Time**: 30 minutes

## Instructions

### Exercise 1: 

#### Task 1: Inspect Jenkins Pipeline

1. In the Azure portal, open the CloudShell pane, start Bash.

1. Get the AppID of the Kubernetes cluster

```bash
RESOURCE_GROUP='AADesignLab0403-RG'

LOCATION='westeurope'

APP_ID=$(az ad sp list --all --query "[?appDisplayName=='AADesignLab0403-SP'].[appId]" --output tsv)
```

1. Vestibulum hendrerit orci urna, non aliquet eros eleifend vitae. 

1. Curabitur nibh dui, vestibulum cursus neque commodo, aliquet accumsan risus. 

    ```
    Sed at malesuada orci, eu volutpat ex
    ```

1. In ac odio vulputate, faucibus lorem at, sagittis felis.

1. Fusce tincidunt sapien nec dolor congue facilisis lacinia quis urna.

    > **Note**: Ut feugiat est id ultrices gravida.

1. Phasellus urna lacus, luctus at suscipit vitae, maximus ac nisl. 

    - Morbi in tortor finibus, tempus dolor a, cursus lorem. 

    - Maecenas id risus pharetra, viverra elit quis, lacinia odio. 

    - Etiam rutrum pretium enim. 

1. Curabitur in pretium urna, nec ullamcorper diam. 

#### Review

Maecenas fringilla ac purus non tincidunt. Aenean pellentesque velit id suscipit tempus. Cras at ullamcorper odio.

### Exercise 2: 

#### Task 1: 

1. Quisque dictum convallis metus, vitae vestibulum turpis dapibus non.

    1. Suspendisse commodo tempor convallis. 

    1. Nunc eget quam facilisis, imperdiet felis ut, blandit nibh. 

    1. Phasellus pulvinar ornare sem, ut imperdiet justo volutpat et.

1. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. 

1. Vestibulum hendrerit orci urna, non aliquet eros eleifend vitae. 

1. Curabitur nibh dui, vestibulum cursus neque commodo, aliquet accumsan risus. 

    ```
    Sed at malesuada orci, eu volutpat ex
    ```

1. In ac odio vulputate, faucibus lorem at, sagittis felis.

1. Fusce tincidunt sapien nec dolor congue facilisis lacinia quis urna.

    > **Note**: Ut feugiat est id ultrices gravida.

1. Phasellus urna lacus, luctus at suscipit vitae, maximus ac nisl. 

    - Morbi in tortor finibus, tempus dolor a, cursus lorem. 

    - Maecenas id risus pharetra, viverra elit quis, lacinia odio. 

    - Etiam rutrum pretium enim. 

1. Curabitur in pretium urna, nec ullamcorper diam. 

#### Task 2: 

1. Quisque dictum convallis metus, vitae vestibulum turpis dapibus non.

    1. Suspendisse commodo tempor convallis. 

    1. Nunc eget quam facilisis, imperdiet felis ut, blandit nibh. 

    1. Phasellus pulvinar ornare sem, ut imperdiet justo volutpat et.

1. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. 

1. Vestibulum hendrerit orci urna, non aliquet eros eleifend vitae. 

1. Curabitur nibh dui, vestibulum cursus neque commodo, aliquet accumsan risus. 

    ```
    Sed at malesuada orci, eu volutpat ex
    ```

1. In ac odio vulputate, faucibus lorem at, sagittis felis.

1. Fusce tincidunt sapien nec dolor congue facilisis lacinia quis urna.

    > **Note**: Ut feugiat est id ultrices gravida.

1. Phasellus urna lacus, luctus at suscipit vitae, maximus ac nisl. 

    - Morbi in tortor finibus, tempus dolor a, cursus lorem. 

    - Maecenas id risus pharetra, viverra elit quis, lacinia odio. 

    - Etiam rutrum pretium enim. 

1. Curabitur in pretium urna, nec ullamcorper diam. 

#### Review

Maecenas fringilla ac purus non tincidunt. Aenean pellentesque velit id suscipit tempus. Cras at ullamcorper odio.