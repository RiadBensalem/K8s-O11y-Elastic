terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.10.0"
    }
    elasticstack = {
      source = "elastic/elasticstack"
      version = "0.11.2"
    }
  }
}

provider "ec" {
}

provider "elasticstack" {
  elasticsearch {
    username  = ec_deployment.k8s_observability.elasticsearch_username
    password  = ec_deployment.k8s_observability.elasticsearch_password
    endpoints = [ec_deployment.k8s_observability.elasticsearch.https_endpoint]
  }
}