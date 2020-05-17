locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

}

resource "vultr_ssh_key" "keys" {

  for_each = local.decoded_yaml.keys != null ? local.decoded_yaml.keys : {}

  name = each.key
  ssh_key = each.value.ssh_key
}
