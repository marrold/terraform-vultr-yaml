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
