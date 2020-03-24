module "build_networks" {
  source = "./modules/network"

  region_ids = local.region_ids
  yaml = file("networks.yaml")

}

module "build_firewalls" {
  source = "./modules/firewalls"

  yaml = file("firewalls.yaml")

}

module "build_servers" {
  source = "./modules/server"

  region_ids   = local.region_ids
  plan_ids     = local.plan_ids
  os_ids       = local.os_ids
  network_ids  = module.build_networks.network_ids
  firewall_ids = module.build_firewalls.firewall_ids
  script_ids   = local.script_ids

  yaml         = file("servers.yaml")

}
