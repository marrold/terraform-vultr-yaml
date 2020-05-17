locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

}

resource "vultr_server" "server" {

    for_each = try(local.decoded_yaml.servers != null ? local.decoded_yaml.servers : tomap(false), {})

    plan_id           = lookup(each.value, "plan", null) != null ? var.plan_ids["${each.value.plan}"].id : 201                # Defaults to £5 instance
    region_id         = lookup(each.value, "region", null) != null ? var.region_ids["${each.value.region}"].id : 8            # Defaults to London
    firewall_group_id = lookup(each.value, "firewall", null)!= null ? var.firewall_ids["${each.value.firewall}"].id : null    # Defaults to none

    os_id             = lookup(each.value, "os", null) != null ? var.os_ids["${each.value.os}"].id : null
    iso_id            = lookup(each.value, "iso", null)!= null ? var.iso_ids["${each.value.iso}"].id : null

    label     = each.key
    tag       = each.key
    hostname  = each.key
    script_id = lookup(each.value, "script", null) != null ? var.script_ids["${each.value.script}"].id : null

    # This mess will generate a list of key_ids. If none are specified it generates an empty list.
    # If the key doesn't exist it will fail with the cryptic error "Null values are not allowed for this attribute value."
    ssh_key_ids = lookup(each.value, "keys", null) != null ? flatten([
      for key in each.value.keys : [
        lookup(var.key_ids, "${key}", null) != null ? var.key_ids[key].id : null
      ]
    ]) : []

    # This mess will generate a list of network_ids. If none are specified it generates an empty list.
    # If the network doesn't exist it will fail with the cryptic error "Null values are not allowed for this attribute value."
    network_ids = lookup(each.value, "private_networks", null) != null ? flatten([
      for network in each.value.private_networks : [
        lookup(var.network_ids, "${network}", null) != null ? var.network_ids[network].id : null
      ]
    ]) : []

    # We set some defaults
    user_data       = "{}"
    enable_ipv6     = false
    auto_backup     = false
    ddos_protection = false
    notify_activate = false

}
