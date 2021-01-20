#########################
#                       #
#       FIREWALLS       #
#                       #
#########################

output "firewall_ids" {
  value = vultr_firewall_group.firewall_group
}


#########################
#                       #
#         ISOS          #
#                       #
#########################

output "iso_ids" {
  value = vultr_iso_private.iso
}


#########################
#                       #
#         KEYS          #
#                       #
#########################

output "key_ids" {
  value = vultr_ssh_key.keys
}


#########################
#                       #
#       NETWORKS        #
#                       #
#########################

output "network_ids" {
  value = vultr_private_network.network
}

