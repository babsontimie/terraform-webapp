provider "azurerm" {
  features {}
  subscription_id = "95fbbc3d-a6cd-46ba-a12d-0f923877e0bb"
}

resource "azurerm_service_plan" "githubActions-svcplan" {
  name                = "${var.prefix}-svcplan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "githubActions-web-app" {
  name                = "${var.prefix}-web-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.githubActions-svcplan.id

  site_config {
    always_on = false
               }
}

# resource "azurerm_linux_web_app_slot" "GithubActions-webapp-slot" {
#   name           = "${var.prefix}-slot"
#   app_service_id = azurerm_linux_web_app.githubActions-web-app.id

#   site_config {
#     always_on = false
#                }
# }
