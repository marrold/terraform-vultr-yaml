module "vultr" {
  source = "./modules/vultr"

  script_ids   = local.script_ids

  instance_yaml      = file("servers.yaml")
  key_yaml           = file("keys.yaml")
  iso_yaml           = file("isos.yaml")
  firewall_yaml      = file("firewalls.yaml")
  networks_yaml      = file("networks.yaml")

}
