locals {

  key_raw_yaml = var.key_yaml
  key_decoded_yaml = yamldecode(local.key_raw_yaml)

}

resource "vultr_ssh_key" "keys" {

  for_each = local.key_decoded_yaml.keys != null ? local.key_decoded_yaml.keys : {}

  name = each.key
  ssh_key = each.value.ssh_key
}
