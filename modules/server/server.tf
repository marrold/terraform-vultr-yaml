locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

}

resource "vultr_server" "server" {

    for_each = local.decoded_yaml.servers != null ? local.decoded_yaml.servers : {}

    plan_id           = lookup(each.value, "plan", null) != null ? var.plan_ids["${each.value.plan}"].id : 201                # Defaults to £5 instance
    region_id         = lookup(each.value, "region", null) != null ? var.region_ids["${each.value.region}"].id : 8            # Defaults to London
    os_id             = lookup(each.value, "os", null) != null ? var.os_ids["${each.value.os}"].id : 352                      # Defaults to Debian 10
    firewall_group_id = lookup(each.value, "firewall", null)!= null ? var.firewall_ids["${each.value.firewall}"].id : null    # Defaults to none

    label     = each.key
    tag       = each.key
    hostname  = each.key
    script_id = lookup(each.value, "script", null) != null ? var.script_ids["${each.value.script}"].id : null

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