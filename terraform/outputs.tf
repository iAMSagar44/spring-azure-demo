output "azurerm_mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.sql_flex_demo.name
}

output "admin_login" {
  value = azurerm_mysql_flexible_server.sql_flex_demo.administrator_login
}

output "admin_password" {
  sensitive = true
  value     = azurerm_mysql_flexible_server.sql_flex_demo.administrator_password
}

output "mysql_flexible_server_database_name" {
  value = azurerm_mysql_flexible_database.demo_db.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "datasource_url" {
  value     = azurerm_key_vault_secret.kv_secret_03.value
  sensitive = true
}