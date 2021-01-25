module "terraform-vultr-yaml" {
  
  source = "github.com/marrold/terraform-vultr-yaml?ref=v0.1"

  instance_yaml_dirs  = ["config-files/yaml-files", "config-files/other-yaml-files"]
  key_yaml_dirs       = ["config-files/yaml-files"]
  iso_yaml_dirs       = ["config-files/yaml-files"]
  firewall_yaml_dirs  = ["config-files/yaml-files"]
  network_yaml_dirs   =  ["config-files/yaml-files"]

  startup_script_dirs = ["config-files/startup-scripts", "config-files/otherscripts"]

}