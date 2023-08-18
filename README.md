# Loading Secrets From Azure Key Vault in Spring Boot Application

This code demonstrates how to load secrets from Azure Key Vault using Spring Cloud Azure.

## What You Need

- [An Azure subscription](https://azure.microsoft.com/free/)
- [Terraform](https://www.terraform.io/)
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [JDK8](https://www.oracle.com/java/technologies/downloads/) or later
- Maven
- You can also import the code straight into your IDE:
    - [IntelliJ IDEA](https://www.jetbrains.com/idea/download)

## Provision Azure Resources Required to Run This Sample

### Authenticate Using the Azure CLI
Terraform must authenticate to Azure to create infrastructure.

In your terminal, use the Azure CLI tool to setup your account permissions locally.

```shell
az login
```

Your browser window will open and you will be prompted to enter your Azure login credentials. After successful authentication, your terminal will display your subscription information. You do not need to save this output as it is saved in your system for Terraform to use.

If you have more than one subscription, specify the subscription-id you want to use with command below: 
```shell
az account set --subscription <your-subscription-id>
```

### Provision the Resources
After login Azure CLI with your account, now you can use the terraform script to create Azure Resources.

Before running the Terraform scripts, update the firewall rule for the Azure MySQL Database Server with your client ip. This is to ensure the application which you will be running locally can connect to the SQL Database in Azure.
Update end_ip_address and start_ip_address in the main.tf file with your ip address. Verify your IP address before saving the configuration. You can use a search engine or other online tool to check your own IP address. For example, search for "what is my IP."

#### Run with Bash

```shell
# In the root directory of the sample
# Initialize your Terraform configuration
terraform -chdir=./terraform init

# Apply your Terraform Configuration
terraform -chdir=./terraform apply

```
It will take a few minutes for the script to run. After the script is successfully executed, you will notice some outputs generated in your shell window (based on the outputs.tf file).

You can go to [Azure portal](https://ms.portal.azure.com/) in your web browser to check the resources you created.

## Setting the Database users

Before you run the application you need to set up users in the Database you just deployed using Terraform.
The Terraform scripts would have deployed and configured a database named 'demo_db' in Azure. 
Run this command to verify if the database has been deployed and configured.

```shell
az mysql flexible-server db show --resource-group springcloudapp-poc-rg --server-name spring-demo-mysql-flexible-server --database-name demo_db
```
Connect to this Database using Azure CLI. Replace the username and password parameters below with the Database admin username and password that was created as part of the Database deployment.You can get the Database Admin Username and password by entering the terraform directory and running the following commands - terraform output admin_login and terraform output admin_password

```shell
az mysql flexible-server connect -n spring-demo-mysql-flexible-serve -u username -p "password" -d demo_db --interactive
```
Once you are connected to the Database, you can create a non admin user that is used by the Spring Boot Application and that is configured in Azure Key Vault as secrets. In this application the non admin user and password is 'springapp_01' and 'springapp#44'.

In the SQL shell window, run the following commands.

```shell
CREATE USER 'springapp_01'@'%' IDENTIFIED BY 'springapp#44';

GRANT ALL PRIVILEGES ON demo_db . * TO 'springapp_01'@'%';

FLUSH PRIVILEGES;
```
You can now connect to the database with this new user.

## Run Locally

### Run the sample with Maven

In your terminal, run `mvn clean spring-boot:run`.

```shell
mvn clean spring-boot:run
```

## Clean Up Resources
After running the sample, if you don't want to run the sample, remember to destroy the Azure resources you created to avoid unnecessary billing.

The terraform destroy command terminates resources managed by your Terraform project.   
To destroy the resources you created.

#### Run with Bash

```shell
terraform -chdir=./terraform destroy -auto-approve
```
