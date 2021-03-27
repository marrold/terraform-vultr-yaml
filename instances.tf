# Build a list of full paths to yaml files
locals {
  instance_file_full_paths = flatten([

    for path in var.instance_yaml_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  # Build a list of decoded yaml file contents
  decoded_instance_yaml_files = flatten([
    for full_path in local.instance_file_full_paths :
      try(yamldecode(file(full_path)), {})
  ])

  # Extract the instance configs and their names and store them in a list, one item per yaml file.
  extracted_instances = flatten([
    for instance_map in local.decoded_instance_yaml_files :
      lookup(instance_map, "instances", {})
  ])
 
  # Merge everything into a single map
  merged_instances = zipmap(
    flatten(
      [for item in local.extracted_instances  : try(keys(item), [])]
    ),
    flatten(
      [for item in local.extracted_instances : try(values(item), [])]
    )
  )

  firewall_ids = vultr_firewall_group.firewall_group
  iso_ids = vultr_iso_private.iso
  key_ids = vultr_ssh_key.key
  network_ids = vultr_private_network.network

}

resource "vultr_instance" "instance" {

    for_each = try(local.merged_instances != null ? local.merged_instances : tomap(false), {})

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
    user_data        =  "{${lookup(each.value, "user_data", null) != null ? join(",", formatlist("\"%s\":\"%s\"", keys(each.value.user_data), values(each.value.user_data))) : ""}}"
    enable_ipv6      = false
    backups          = false
    ddos_protection  = false
    activation_email = false

}

