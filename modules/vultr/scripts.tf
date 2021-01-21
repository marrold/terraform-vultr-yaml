resource "vultr_startup_script" "script" {
  for_each = fileset(var.startup_script_dir, "**")
    name = each.key
    script = base64encode(file("${var.startup_script_dir}/${each.key}"))
}

output "script_ids" {
  value = vultr_startup_script.script
}