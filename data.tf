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
