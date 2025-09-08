variable "prefix" {
  type    = string
  default = "bluegreen"

}

variable "env" {
  type    = string
  default = "dev"

}
variable "resource_group_name" {}
variable "location" {}

variable "sku_name" {}
variable "max_size_gb" {}
variable "read_scale" {}
