
#Add a data source to get SP info (optional)

#data "azurerm_client_config" "current" {}


# Create Key Vault

resource "azurerm_key_vault" "db_kv" {
  name                     = "${var.prefix}-kv"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
#  soft_delete_enabled      = true
  purge_protection_enabled = false
}

resource "azurerm_key_vault_access_policy" "sp_kv_access" {
  key_vault_id = azurerm_key_vault.db_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "Set",
    "List"
  ]
}



# Add Secrets

resource "azurerm_key_vault_secret" "db_password" {
  name         = "DbPassword"
  value        = "Kala8Kuta%"
  key_vault_id = azurerm_key_vault.db_kv.id

  depends_on = [azurerm_key_vault_access_policy.sp_kv_access]
}

resource "azurerm_key_vault_secret" "db_username" {
  name         = "DbUsername"
  value        = "teeadmin"
  key_vault_id = azurerm_key_vault.db_kv.id

  depends_on = [azurerm_key_vault_access_policy.sp_kv_access]
}

resource "azurerm_key_vault_secret" "db_server" {
  name         = "DbServer"
  value        = "${var.prefix}-sqlserver"
  key_vault_id = azurerm_key_vault.db_kv.id

  depends_on = [azurerm_key_vault_access_policy.sp_kv_access]
}

resource "azurerm_key_vault_secret" "db_name" {
  name         = "DbName"
  value        = "${var.prefix}-database"
  key_vault_id = azurerm_key_vault.db_kv.id

  depends_on = [azurerm_key_vault_access_policy.sp_kv_access]
}

