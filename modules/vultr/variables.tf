#########################
#                       #
#       INSTANCES       #
#                       #
#########################

variable "instance_yaml" {
  description = "Contents of servers.yaml"
  type = string
}


#########################
#                       #
#       FIREWALLS       #
#                       #
#########################

variable "firewall_yaml" {
  description = "Contents of firewall.yaml"
  type = string
}


#########################
#                       #
#          ISOS         #
#                       #
#########################

variable "iso_yaml" {
  description = "Contents of iso.yaml"
  type = string
}


#########################
#                       #
#          KEYS         #
#                       #
#########################

variable "key_yaml" {
  description = "Contents of keys.yaml"
  type = string
}


#########################
#                       #
#       NETWORKS        #
#                       #
#########################

variable "networks_yaml" {
  description = "Contents of networks.yaml"
  type = string
}

#########################
#                       #
#        SCRIPTS        #
#                       #
#########################

variable "startup_script_dir" {
  description = "Path to startup script directory"
  type = string
}
