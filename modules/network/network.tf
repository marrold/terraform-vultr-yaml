locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

}

resource "vultr_private_network" "network" {

  for_each = local.decoded_yaml.networks != null ? local.decoded_yaml.networks : {}

  description = each.value.description
  region      = var.region_ids[each.value.region].id

  v4_subnet  = element(split("/", each.value.cidr_block), 0)
  v4_subnet_mask = element(split("/", each.value.cidr_block), 1)

}
