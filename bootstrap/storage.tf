
resource "azurerm_storage_account" "bluegreen-storacct" {
  name                     = "${var.prefix}storaccount"
  resource_group_name      = azurerm_resource_group.bluegreen-resgrp.name
  location                 = azurerm_resource_group.bluegreen-resgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.prefix}-storaccount"
  }

  #   timeouts {
  #   create = "10m"
  # }
}

resource "azurerm_storage_container" "bluegreen" {
  name                  = "${var.prefix}-tfstate"
  storage_account_id    = azurerm_storage_account.bluegreen-storacct.id
  container_access_type = "private"
}
