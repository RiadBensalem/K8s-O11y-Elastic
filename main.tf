data "ec_stack" "latest" {
  version_regex = "latest"
  region        = "eu-west-1"
}

resource "ec_deployment" "k8s_observability" {
  # Optional name.
  name = "k8s_observability"

  region                 = "eu-west-1"
  version                = data.ec_stack.latest.version
  deployment_template_id = "aws-storage-optimized"

  elasticsearch = {
    hot = {
      autoscaling = {}
    }
  }

  kibana = {}
  integrations_server = {}

  # Optional observability settings
  observability = {
  deployment_id = "self"
}

  tags = {
    "monitoring" = "source"
  }
}
