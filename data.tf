##########################
#         PLANS          #
##########################

data "vultr_plan" "nano" {
  filter {
    name   = "id"
    #values = ["1024 MB RAM,25 GB SSD,1.00 TB BW"]
    values = ["vc2-1c-1gb"]
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
    name   = "id"
    values = ["ewr"]
  }
}

data "vultr_region" "london" {
  filter {
    name   = "id"
    values = ["lhr"]
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
    script = base64encode(file("./startup-scripts/Default-Debian.sh"))
}

locals {
  script_ids = {
    Default-Debian: vultr_startup_script.Default-Debian
  }
}
