provider "azurerm" {
  features {}
  subscription_id = "95fbbc3d-a6cd-46ba-a12d-0f923877e0bb"
}

# resource "azurerm_service_plan" "githubActions-svcplan" {
#  name                = "${var.prefix}-svcplan"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  os_type             = "Linux"
#  sku_name            = "F1"
#}

#resource "azurerm_linux_web_app" "githubActions-web-app" {
#  name                = "${var.prefix}-web-app"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  service_plan_id     = azurerm_service_plan.githubActions-svcplan.id
#
#  site_config {
#    dotnet_framework_version = "v2.0"
#    scm_type = "LocalGit"
#    always_on = false
#               }
#}

# resource "azurerm_linux_web_app_slot" "GithubActions-webapp-slot" {
#   name           = "${var.prefix}-slot"
#   app_service_id = azurerm_linux_web_app.githubActions-web-app.id

#   site_config {
#     always_on = false
#                }
# }

resource "azurerm_service_plan" "githubActions-svcplan" {
  name                = "${var.prefix}-svcplan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "githubActions-web-app" {
  name                = "${var.prefix}-web-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.githubActions-svcplan.id

  site_config {
    always_on = false
  }
  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:azurerm_mssql_server.githubActions-server.fully_qualified_domain_name  Database=azurerm_mssql_database.githubActions-dbase.name;User ID=azurerm_mssql_server.githubActions-server.administrator_login;Password=Database=azurerm_mssql_server.githubActions-server.administrator_login_password;Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_linux_web_app_slot" "GithubActions-webapp-slot" {
  name           = "${var.prefix}-slot"
  app_service_id = azurerm_linux_web_app.githubActions-web-app.id
  site_config {
    always_on = false
  }
}


resource "azurerm_app_service_source_control" "githubActions-scontrol" {
  app_id   = azurerm_linux_web_app.githubActions-web-app.id
  repo_url = "https://github.com/babsontimie/tf-sample-bg"
  branch   = "master"
}

resource "azurerm_app_service_source_control_slot" "githubActions-slot" {
  slot_id  = azurerm_linux_web_app_slot.GithubActions-webapp-slot.id
  repo_url = "https://github.com/babsontimie/tf-sample-bg"
  branch   = "master"

}

resource "azurerm_web_app_active_slot" "githubActions-active-slot" {
  slot_id = azurerm_linux_web_app_slot.GithubActions-webapp-slot.id
}
