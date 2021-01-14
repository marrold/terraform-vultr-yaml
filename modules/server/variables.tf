variable "yaml" {
  description = "Contents of servers.yaml"
  type = string
}

variable "region_ids" {
  description = "Map of Region IDs"
  default = {}
}

variable "plan_ids" {
  description = "Map of Plan IDs"
  default = {}
}

variable "os_ids" {
  description = "Map of OS IDs"
  default = {}
}

variable "network_ids" {
  description = "Map of Network IDs"
  default = {}
}

variable "script_ids" {
  description = "Map of Script IDs"
  default = {}
}

variable "firewall_ids" {
  description = "Map of Firewall IDs"
  default = {}
}

variable "iso_ids" {
  description = "Map of ISO IDs"
  default = {}
}

variable "key_ids" {
  description = "Map of key IDs"
  default = {}
}
