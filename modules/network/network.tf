locals {

  raw_yaml = var.yaml
  decoded_yaml = try(yamldecode(local.raw_yaml), {})

}

resource "vultr_private_network" "network" {

  for_each = try(local.decoded_yaml.networks != null ? local.decoded_yaml.networks : tomap(false), {})

  description = each.value.description
  region      = var.region_ids[each.value.region].id

  v4_subnet  = element(split("/", each.value.cidr_block), 0)
  v4_subnet_mask = element(split("/", each.value.cidr_block), 1)

}
