locals {

  raw_yaml = var.yaml
  decoded_yaml = try(yamldecode(local.raw_yaml), {})

}

resource "vultr_iso_private" "iso" {

    for_each = try(local.decoded_yaml.isos != null ? local.decoded_yaml.isos : tomap(false), {})

    url = each.value.url
}
