locals {

  # Build a list of full paths to yaml files
  network_file_full_paths = flatten([

    for path in var.network_yaml_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  # Build a list of decoded yaml file contents
  decoded_network_yaml_files = flatten([
    for full_path in local.network_file_full_paths :
      try(yamldecode(file(full_path)), {})
  ])

  # Extract the network configs and their names and store them in a list. 
  # Each item in the list is all the networks held in a single yaml file.
  extracted_networks = flatten([
    for network_map in local.decoded_network_yaml_files :
      lookup(network_map, "networks", {})
  ])

  # Merge everything into a single map
  merged_networks = zipmap(
    flatten(
      [for item in local.extracted_networks  : try(keys(item), [])]
    ),
    flatten(
      [for item in local.extracted_networks : try(values(item), [])]
    )
  )
}

resource "vultr_private_network" "network" {

  for_each = try(local.merged_networks != null ? local.merged_networks : tomap(false), {})

  description = each.value.description
  region      = local.region_ids[each.value.region].id

  v4_subnet  = element(split("/", each.value.cidr_block), 0)
  v4_subnet_mask = element(split("/", each.value.cidr_block), 1)

}
