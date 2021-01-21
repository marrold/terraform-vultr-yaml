locals {

  iso_raw_yaml = var.iso_yaml
  iso_decoded_yaml = try(yamldecode(local.iso_raw_yaml), {})

}

resource "vultr_iso_private" "iso" {

    for_each = try(local.iso_decoded_yaml.isos != null ? local.iso_decoded_yaml.isos : tomap(false), {})

    url = each.value.url
}
