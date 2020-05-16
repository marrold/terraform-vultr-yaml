locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

}

resource "vultr_iso_private" "iso" {

    for_each = local.decoded_yaml.isos != null ? local.decoded_yaml.isos : {}

    url = each.value.url
}
