#########################
#                       #
#       INSTANCES       #
#                       #
#########################

variable "instance_yaml_dirs" {
  description = "List of paths to directories containing yaml files including instances"
  type = list
}


#########################
#                       #
#       FIREWALLS       #
#                       #
#########################

variable "firewall_yaml_dirs" {
  description = "List of paths to directories containing yaml files including firewalls"
  type = list
}


#########################
#                       #
#          ISOS         #
#                       #
#########################

variable "iso_yaml_dirs" {
  description = "List of paths to directories containing yaml files including isos"
  type = list
}


#########################
#                       #
#          KEYS         #
#                       #
#########################

variable "key_yaml_dirs" {
  description = "List of paths to directories containing yaml files including keys"
  type = list
}


#########################
#                       #
#       NETWORKS        #
#                       #
#########################

variable "network_yaml_dirs" {
  description = "List of paths to directories containing yaml files including networks"
  type = list
}

#########################
#                       #
#        SCRIPTS        #
#                       #
#########################

variable "startup_script_dirs" {
  description = "List of paths to directories containing scripts"
  type = list
}
