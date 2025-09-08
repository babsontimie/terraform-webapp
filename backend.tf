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
    resource_group_name  = "bluegreen-resgrp"
    storage_account_name = "bluegreenstoraccount"
    container_name       = "bluegreen-tfstate"
    key                  = "remote/terraform.tfstate"
  }
}
