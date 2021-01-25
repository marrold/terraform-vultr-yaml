locals {

  # Build a list of full paths to yaml files
  key_file_full_paths = flatten([

    for path in var.key_yaml_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  # Build a list of decoded yaml file contents
  decoded_key_yaml_files = flatten([
    for full_path in local.key_file_full_paths :
      try(yamldecode(file(full_path)), {})
  ])

  # Extract the ssh keys and their names and store them in a list.
  # Each item in the list is all the keys held in a single yaml file.
  extracted_keys = flatten([
    for key_map in local.decoded_key_yaml_files :
      lookup(key_map, "keys", {})
  ])

  # Merge everything into a single map
  merged_keys = zipmap(
    flatten(
      [for item in local.extracted_keys  : try(keys(item), [])]
    ),
    flatten(
      [for item in local.extracted_keys : try(values(item), [])]
    )
  )
}

resource "vultr_ssh_key" "key" {

  for_each = local.merged_keys != null ? local.merged_keys : {}

  name = each.key
  ssh_key = each.value.ssh_key
}
