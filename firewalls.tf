locals {

  # Build a list of full paths to yaml files
  firewall_file_full_paths = flatten([

    for path in var.firewall_yaml_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  # Build a list of decoded yaml file contents
  decoded_firewall_yaml_files = flatten([
  
    for full_path in local.firewall_file_full_paths :
      try(yamldecode(file(full_path)), {})
  ])

  # Extract the firewall configs and their names and store them in a list. 
  # Each item in the list is all the firewalls held in a single yaml file.
  extracted_firewalls = flatten([
  
    for firewall_map in local.decoded_firewall_yaml_files :
      lookup(firewall_map, "firewalls", {})
  ])

  # This works. Dont touch it.
  # It takes all the groups and their rules from all files and builds a map. The keys are hash of the rule 
  # parameters, to avoid clashes
  firewall_rules = {
    
    for index, rule in flatten([
      for file in local.extracted_firewalls : [
        for group in try(keys(file), []) : [
          for rules_list in file[group] : [
            merge(rules_list, {"firewall_group" = group})
          ]
        ]
      ]
    ]) : sha256(format("%s%s%s%s", rule.notes, rule.firewall_group, rule.network, rule.protocol)) => rule
  }

  # Get just the groups, and create a map. The key and value are the same, cos resources need a map to use for_each
  # rather than a list.
  firewall_groups = { 

    for index, group in flatten([
      for file in local.extracted_firewalls : [
        for group in try(keys(file), []) : 
          group

      ]
    ]) : format("%s", group) => group
  }
}

resource "vultr_firewall_group" "firewall_group" {

  for_each = try(local.firewall_groups, {})

    description = each.value

}

resource "vultr_firewall_rule" "firewall_rule" {

  for_each = local.firewall_rules != null ? local.firewall_rules : {}

    firewall_group_id = vultr_firewall_group.firewall_group[each.value.firewall_group].id

    protocol    = each.value.protocol
    
    ip_type     = "v4"
    subnet      = element(split("/", each.value.network), 0)
    subnet_size = element(split("/", each.value.network), 1) 
    port        = each.value.protocol != "icmp" ? lookup(each.value, "port", "1:65535") : ""
    notes       = each.value.notes
}
