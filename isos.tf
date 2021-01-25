locals {

  # Build a list of full paths to yaml files
  iso_file_full_paths = flatten([

    for path in var.iso_yaml_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  # Build a list of decoded yaml file contents
  decoded_iso_yaml_files = flatten([
    for full_path in local.iso_file_full_paths :
      try(yamldecode(file(full_path)), {})
  ])

  # Extract the iso urls and their names and store them in a list. 
  # Each item in the list is all the isos held in a single yaml file.
  extracted_isos = flatten([
    for iso_map in local.decoded_iso_yaml_files :
      lookup(iso_map, "isos", {})
  ])

  # Merge everything into a single map
  merged_isos = zipmap(
    flatten(
      [for item in local.extracted_isos : try(keys(item), [])]
    ),
    flatten(
      [for item in local.extracted_isos : try(values(item), [])]
    )
  )
}

resource "vultr_iso_private" "iso" {

    for_each = try(local.merged_isos != null ? local.merged_isos : tomap(false), {})

    url = each.value.url
}
