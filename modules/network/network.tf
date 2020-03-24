locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

}

resource "vultr_network" "network" {

  for_each = local.decoded_yaml.networks

  description = each.value.description
  region_id   = var.region_ids["${each.value.region}"].id
  cidr_block  = each.value.cidr_block

}
