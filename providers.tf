terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.10.0"
    }
    
  }
}

provider "ec" {
}