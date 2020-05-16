variable "yaml" {
  description = "Contents of servers.yaml"
  type = string
}

variable "region_ids" {
  description = "Map of Region IDs"
}

variable "plan_ids" {
  description = "Map of Plan IDs"
}

variable "os_ids" {
  description = "Map of OS IDs"
}

variable "network_ids" {
  description = "Map of Network IDs"
}

variable "script_ids" {
  description = "Map of Script IDs"
}

variable "firewall_ids" {
  description = "Map of Firewall IDs"
}

variable "iso_ids" {
  description = "Map of ISO IDs"
}
