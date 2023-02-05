provider "aws" {
  region  = "ap-southeast-2"
  profile = "paw"
}

variable "module_name" {
  default = "ray-eventbridge"
}

locals {
  tags = {
    name = var.module_name
  }
}

