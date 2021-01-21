locals {

  instances_raw_yaml = var.instance_yaml
  instances_decoded_yaml = try(yamldecode(local.instances_raw_yaml), {})

  firewall_ids = vultr_firewall_group.firewall_group
  iso_ids = vultr_iso_private.iso
  key_ids = vultr_ssh_key.keys
  network_ids = vultr_private_network.network

}

resource "vultr_instance" "server" {

    for_each = try(local.instances_decoded_yaml.servers != null ? local.instances_decoded_yaml.servers : tomap(false), {})

    plan              = lookup(each.value, "plan", null) != null ? local.plan_ids[each.value.plan].id : "vc2-1c-1gb"       # Defaults to £5 instance
    region            = lookup(each.value, "region", null) != null ? local.region_ids[each.value.region].id : "lhr"        # Defaults to London
    firewall_group_id = lookup(each.value, "firewall", null)!= null ? local.firewall_ids[each.value.firewall].id : null    # Defaults to none

    os_id             = lookup(each.value, "os", null) != null ? local.os_ids[each.value.os].id : null
    iso_id            = lookup(each.value, "iso", null)!= null ? local.iso_ids[each.value.iso].id : null

    label     = each.key
    tag       = each.key
    hostname  = each.key
    script_id = lookup(each.value, "script", null) != null ? vultr_startup_script.script[each.value.script].id : null

    # This mess will generate a list of key_ids. If none are specified it generates an empty list.
    # If the key doesn't exist it will fail with the cryptic error "Null values are not allowed for this attribute value."
    ssh_key_ids = lookup(each.value, "keys", null) != null ? flatten([
      for key in each.value.keys : [
        lookup(local.key_ids, key, null) != null ? list(local.key_ids[key].id) : []
      ]
    ]) : []

    # This mess will generate a list of network_ids. If none are specified it generates an empty list.
    # If the network doesn't exist it will fail with the cryptic error "Null values are not allowed for this attribute value."
    private_network_ids = lookup(each.value, "private_networks", null) != null ? flatten([
      for network in each.value.private_networks : [
        lookup(local.network_ids, network, null) != null ? local.network_ids[network].id : null
      ]
    ]) : []

    # We set some defaults
    user_data        = "{}"
    enable_ipv6      = false
    backups          = false
    ddos_protection  = false
    activation_email = false

}