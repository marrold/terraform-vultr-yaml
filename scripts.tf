locals {
  # Build a list of full paths to yaml files
  script_file_full_paths = flatten([

    for path in var.startup_script_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  # Build a list of file names
  script_file_names = flatten([
    for path in var.startup_script_dirs : [
      for file_name in fileset(path, "**") :
        file_name
    ]
  ])

  # Build a list of file contents
  script_file_contents = [
    for full_path in local.script_file_full_paths :
      try(base64encode(file(full_path)), {})
  ]

  merged_scripts= zipmap(local.script_file_names, local.script_file_contents)

}

resource "vultr_startup_script" "script" {
  for_each = local.merged_scripts
    name = each.key
    script = each.value
}