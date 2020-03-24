##########################
#         PLANS          #
##########################

data "vultr_plan" "nano" {
  filter {
    name   = "name"
    values = ["1024 MB RAM,25 GB SSD,1.00 TB BW"]
  }
}

locals {
  plan_ids = {
    nano: data.vultr_plan.nano
  }
}

##########################
#          OSs           #
##########################

data "vultr_os" "debian_10" {
  filter {
    name   = "name"
    values = ["Debian 10 x64 (buster)"]
  }
}

locals {
  os_ids = {
    debian_10: data.vultr_os.debian_10
  }
}

##########################
#        REGIONS         #
##########################

data "vultr_region" "new-jersey" {
  filter {
    name   = "name"
    values = ["New Jersey"]
  }
}

data "vultr_region" "london" {
  filter {
    name   = "name"
    values = ["London"]
  }
}

locals {
  region_ids = {
    london: data.vultr_region.london
    new-jersey: data.vultr_region.new-jersey
  }
}

##########################
#        SCRIPTS         #
##########################

resource "vultr_startup_script" "Default-Debian" {
    name = "Default-Debian"
    script = file("./startup-scripts/Default-Debian.sh")
}

locals {
  script_ids = {
    Default-Debian: vultr_startup_script.Default-Debian
  }
}
