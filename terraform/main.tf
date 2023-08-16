terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

# Generate random value for the name
resource "random_string" "name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# Generate random value for the login password
resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}

// ===========resource_group===========
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "springcloudapp-poc-rg"
}

data "azurerm_client_config" "current" {

}

// ===========azurerm_key_vault_01===========
resource "azurerm_key_vault" "kv_account_01" {
  location            = var.location
  name                = "az-key-vault-01-rs"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Purge",
      "Delete"
    ]
  }
}

resource "azurerm_mysql_flexible_server" "sql_flex_demo" {
  location                     = "australiaeast"
  name                         = "spring-demo-mysql-flexible-server"
  resource_group_name          = azurerm_resource_group.rg.name
  administrator_login          = random_string.name.result
  administrator_password       = random_password.password.result
  sku_name                     = "B_Standard_B1s"
  version                      = "8.0.21"
  geo_redundant_backup_enabled = false
}

resource "azurerm_mysql_flexible_database" "demo_db" {
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  name                = "demo_db"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.sql_flex_demo.name
}

resource "azurerm_mysql_flexible_server_firewall_rule" "demo_fw" {
  name                = "home"
  resource_group_name = azurerm_resource_group.rg.name
  end_ip_address      = "149.167.181.51" //replace with machine's or app's ip address
  server_name         = azurerm_mysql_flexible_server.sql_flex_demo.name
  start_ip_address    = "149.167.181.51" //replace with machine's or app's ip address
}

resource "azurerm_key_vault_secret" "kv_secret_01" {
  key_vault_id = azurerm_key_vault.kv_account_01.id
  name         = "mysqluser"
  value        = "springapp_01"
}

resource "azurerm_key_vault_secret" "kv_secret_02" {
  key_vault_id = azurerm_key_vault.kv_account_01.id
  name         = "mysqlpwd"
  value        = "springapp#44"
}

resource "azurerm_key_vault_secret" "kv_secret_03" {
  key_vault_id = azurerm_key_vault.kv_account_01.id
  name         = "datasource"
  value = join("", ["jdbc:mysql://", azurerm_mysql_flexible_server.sql_flex_demo.name,
  ".mysql.database.azure.com:3306/", azurerm_mysql_flexible_database.demo_db.name, "?serverTimezone=UTC"])
}


