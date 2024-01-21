Documentation for Azure Pipeline Deployment of Debian 12 VMs with Azure AD Integration and Fail2Ban Configuration
1. Introduction

This repository provides essential resources for deploying Debian 12 virtual machines (VMs) using Azure Pipelines. It includes configurations for integrating Azure Active Directory (Azure AD) for authentication and securing the VMs with Fail2Ban, a tool to protect against brute force attacks.
2. Requirements

    Azure account with appropriate permissions to create and manage VMs.
    Azure CLI installed and configured.
    Knowledge of Azure Pipelines for continuous integration and deployment.
    Basic understanding of YAML, Bicep templates, and Ansible playbooks.

3. Overview of Components
fail2ban.conf

This configuration file sets up Fail2Ban to monitor log files for Kibana and Elasticsearch services, protecting them from brute force attacks. It specifies the ports, log paths, and maximum retry limits.
linuxad.yaml

An Ansible playbook that automates the installation of necessary packages for Azure AD integration and Fail2Ban on Debian VMs. It includes tasks for installing dependencies, configuring Azure AD authentication, and setting up Fail2Ban using the provided fail2ban.conf.
main.bicep

A Bicep template to define the infrastructure in Azure, primarily focusing on the creation of a VM. It specifies the VM size, OS image (Debian 12), network configurations, and an extension to execute Ansible scripts for further configuration.
variable.bicep

Contains variables used in main.bicep for creating the VM. It includes parameters such as VM name, size, network settings, and KeyVault details for secure storage of sensitive data like admin passwords.
4. Configuration and Usage

    Setting Up Azure Pipeline:
        Use the Bicep files (main.bicep and variable.bicep) to define your infrastructure as code in the Azure Pipeline.
        Customize the variable.bicep as per your environment needs.

    Deploying VMs:
        Execute the Bicep templates to deploy VMs in Azure.
        Ensure the VMs meet the requirements (like network and storage configurations).

    Configuring Azure AD Integration:
        Use the linuxad.yaml Ansible playbook to configure Azure AD authentication on the deployed VMs.
        Replace placeholder values in the playbook with actual Azure tenant ID, app ID, and app secret.

    Setting Up Fail2Ban:
        fail2ban.conf should be placed in the /etc/fail2ban/jail.d/ directory on the VM.
        The playbook will automatically configure Fail2Ban with the provided settings for Kibana and Elasticsearch.

    Running the Pipeline:
        Initiate the Azure Pipeline to start the deployment and configuration process.
        Monitor the pipeline for any errors and validate the deployment.

5. Conclusion

This repository offers a streamlined approach for deploying secure Linux VMs with Azure AD integration and enhanced security with Fail2Ban. By following these instructions, you can ensure a robust and automated deployment process in Azure.
