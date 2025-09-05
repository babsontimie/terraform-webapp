provider "azurerm" {
  features {}
  subscription_id = "95fbbc3d-a6cd-46ba-a12d-0f923877e0bb"
}

resource "azurerm_resource_group" "bluegreen-resgrp" {
  name     = "${var.prefix}-resgrp"
  location = "uk south"
}

