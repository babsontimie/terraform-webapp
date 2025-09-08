provider "azurerm" {
  features {}
  subscription_id = "95fbbc3d-a6cd-46ba-a12d-0f923877e0bb"
}

data "azurerm_client_config" "current" {}

resource "azurerm_service_plan" "bluegreen-svcplan" {
  name                = "${var.prefix}-svcplan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
}

# Assign Managed Identity to Web App & Set Access Policy

# Web App

resource "azurerm_linux_web_app" "bluegreen-web-app" {
  name                = "${var.prefix}-web-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.bluegreen-svcplan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = false
  }

  app_settings = {
    "DbPassword" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_password.id})"
    "DbUsername" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_username.id})"
    "DbServer"   = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_server.id})"
    "DbName"     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_name.id})"
  }

  #  connection_string {
  #    name  = "Database"
  #    type  = "SQLServer"
  #    value = "Server=tcp:azurerm_mssql_server.bluegreen-server.fully_qualified_domain_name  Database=azurerm_mssql_database.bluegreen-dbase.name;User ID=azurerm_mssql_server.bluegreen-server.administrator_login;Password=Database=azurerm_mssql_server.bluegreen-server.administrator_login_password;Trusted_Connection=False;Encrypt=True;"
  #  }
}

# Grant Web App access to Key Vault

resource "azurerm_key_vault_access_policy" "webapp_kv_access" {
  key_vault_id = azurerm_key_vault.db_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.bluegreen-web-app.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_linux_web_app_slot" "bluegreen-webapp-slot" {
  name           = "${var.prefix}-slot"
  app_service_id = azurerm_linux_web_app.bluegreen-web-app.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = false
  }
  app_settings = {
    "DbPassword" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_password.id})"
    "DbUsername" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_username.id})"
    "DbServer"   = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_server.id})"
    "DbName"     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_name.id})"
  }

}

# Key Vault Access for Web App Slot
resource "azurerm_key_vault_access_policy" "web_app_slot_access" {
  key_vault_id = azurerm_key_vault.db_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.bluegreen-web-app.identity[0].principal_id

  secret_permissions = ["Get"]
}

# Optional: Source Control (GitHub Actions)

resource "azurerm_app_service_source_control" "bluegreen-scontrol" {
  app_id   = azurerm_linux_web_app.bluegreen-web-app.id
  repo_url = "https://github.com/babsontimie/tf-sample-bg"
  branch   = "master"
}

resource "azurerm_app_service_source_control_slot" "bluegreen-slot" {
  slot_id  = azurerm_linux_web_app_slot.bluegreen-webapp-slot.id
  repo_url = "https://github.com/babsontimie/tf-sample-bg"
  branch   = "master"

}

# Source : 


resource "azurerm_web_app_active_slot" "bluegreen-active-slot" {
  slot_id = azurerm_linux_web_app_slot.bluegreen-webapp-slot.id
}
