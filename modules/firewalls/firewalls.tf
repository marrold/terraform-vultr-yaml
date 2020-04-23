locals {

  raw_yaml = var.yaml
  decoded_yaml = yamldecode(local.raw_yaml)

  firewall_rules_list = flatten([

    for firewall_group in keys(local.decoded_yaml.firewalls) : [

      for firewall_rule in local.decoded_yaml.firewalls[firewall_group] : merge(
        firewall_rule, {"firewall_group" = firewall_group}
      )
    ]
  ])

  merged_firewall_rules = {

    for index, rule in local.firewall_rules_list :
      "${sha256(format("%s%s%s%s", rule.notes, rule.firewall_group, rule.network, rule.protocol))}" => rule
    }

  }

resource "vultr_firewall_group" "firewall_group" {

  for_each = local.decoded_yaml.firewalls

  description = each.key

}

resource "vultr_firewall_rule" "firewall_rule" {

    for_each = local.merged_firewall_rules

    firewall_group_id = vultr_firewall_group.firewall_group[each.value.firewall_group].id

    protocol  = each.value.protocol
    network   = each.value.network
    from_port = lookup(each.value, "from_port", 1)
    to_port   = lookup(each.value, "from_port", null) == null ? 65535 : lookup(each.value, "to_port", null) == null ? null : each.value.to_port
    notes     = each.value.notes

}

output "firewall_rules" {
  value = local.merged_firewall_rules
}
