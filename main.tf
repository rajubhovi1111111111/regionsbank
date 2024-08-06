terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
provider "random" {}

resource "random_string" "unique" {
  length  = 8
  special = false
}


module "connect_instance" {
  source                   = "./modules/connect"
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  outbound_calls_enabled   = true
  instance_alias           = "my-connect-instance-${random_string.unique.result}"
  
}
