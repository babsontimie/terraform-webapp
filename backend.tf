# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-tfstate-demo"
#     storage_account_name = "tdstfstatedemo"
#     container_name       = "tfstate"
#     key                  = "remote-backend-demo/terraform.tfstate"
#   }
# }

terraform {
  backend "azurerm" {
    resource_group_name  = "ghact-resgrp"
    storage_account_name = "ghactstoraccount"
    container_name       = "ghact-tfstate"
    key                  = "remote/terraform.tfstate"
  }
}
