resource "azurerm_mssql_server" "githubActions-server" {
  name                         = "${var.prefix}-sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "ratatata"
  administrator_login_password = "<DB-PW>"

  tags = {
    environment = "${var.prefix}-mssql-server"
  }
}


resource "azurerm_mssql_database" "githubActions-dbase" {
  name                = "${var.prefix}-database"
  server_id = azurerm_mssql_server.githubActions-server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.max_size_gb
  read_scale     = var.read_scale
  sku_name       = var.sku_name
  zone_redundant = false
  geo_backup_enabled = false             # Enables geo backups
  

  tags = {
    environment = "${var.prefix}-database"
  }
}
