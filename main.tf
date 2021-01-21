module "vultr" {
  source = "./modules/vultr"

  instance_yaml      = file("servers.yaml")
  key_yaml           = file("keys.yaml")
  iso_yaml           = file("isos.yaml")
  firewall_yaml      = file("firewalls.yaml")
  networks_yaml      = file("networks.yaml")

  startup_script_dir = "startup-scripts"

}

output "script_ids" {
  value = module.vultr.script_ids
}