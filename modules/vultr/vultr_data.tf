#########################
#                       #
#        REGIONS        #
#                       #
#########################

data "vultr_region" "atlanta" {
  filter {
    name   = "id"
    values = ["atl"]
  }
}

data "vultr_region" "chicago" {
  filter {
    name   = "id"
    values = ["ord"]
  }
}

data "vultr_region" "dallas" {
  filter {
    name   = "id"
    values = ["dfw"]
  }
}

data "vultr_region" "los-angeles" {
  filter {
    name   = "id"
    values = ["lax"]
  }
}

data "vultr_region" "miami" {
  filter {
    name   = "id"
    values = ["mia"]
  }
}

data "vultr_region" "new-jersey" {
  filter {
    name   = "id"
    values = ["ewr"]
  }
}

data "vultr_region" "seattle" {
  filter {
    name   = "id"
    values = ["sea"]
  }
}

data "vultr_region" "silicon-valley" {
  filter {
    name   = "id"
    values = ["sjc"]
  }
}

data "vultr_region" "singapore" {
  filter {
    name   = "id"
    values = ["sgp"]
  }
}

data "vultr_region" "amsterdam" {
  filter {
    name   = "id"
    values = ["ams"]
  }
}

data "vultr_region" "seoul" {
  filter {
    name   = "id"
    values = ["icn"]
  }
}

data "vultr_region" "tokyo" {
  filter {
    name   = "id"
    values = ["nrt"]
  }
}

data "vultr_region" "london" {
  filter {
    name   = "id"
    values = ["lhr"]
  }
}

data "vultr_region" "paris" {
  filter {
    name   = "id"
    values = ["cdg"]
  }
}

data "vultr_region" "frankfurt" {
  filter {
    name   = "id"
    values = ["fra"]
  }
}

data "vultr_region" "toronto" {
  filter {
    name   = "id"
    values = ["yto"]
  }
}

data "vultr_region" "sydney" {
  filter {
    name   = "id"
    values = ["syd"]
  }
}

locals {
  region_ids = {
    atlanta: data.vultr_region.atlanta
    chicago: data.vultr_region.chicago
    dallas: data.vultr_region.dallas
    los-angeles: data.vultr_region.los-angeles
    miami: data.vultr_region.miami
    new-jersey: data.vultr_region.new-jersey
    seattle: data.vultr_region.seattle
    silicon-valley: data.vultr_region.silicon-valley
    singapore: data.vultr_region.singapore
    amsterdam: data.vultr_region.amsterdam
    seoul: data.vultr_region.seoul
    tokyo: data.vultr_region.tokyo
    london: data.vultr_region.london
    paris: data.vultr_region.paris
    frankfurt: data.vultr_region.frankfurt
    toronto: data.vultr_region.toronto
    sydney: data.vultr_region.sydney
  }
}

#########################
#                       #
#          OSs          #
#                       #
#########################

data "vultr_os" "centos_7" {
  filter {
    name   = "name"
    values = ["CentOS 7 x64"]
  }
}

data "vultr_os" "centos_7_selinux" {
  filter {
    name   = "name"
    values = ["CentOS 7 SELinux x64"]
  }
}

data "vultr_os" "centos_8" {
  filter {
    name   = "name"
    values = ["CentOS 8 x64"]
  }
}

data "vultr_os" "centos_8_stream" {
  filter {
    name   = "name"
    values = ["CentOS 8 Stream x64"]
  }
}

data "vultr_os" "ubuntu_16_04" {
  filter {
    name   = "name"
    values = ["Ubuntu 16.04 x64"]
  }
}

data "vultr_os" "ubuntu_16_04_i386" {
  filter {
    name   = "name"
    values = ["Ubuntu 16.04 i386"]
  }
}

data "vultr_os" "ubuntu_18_04" {
  filter {
    name   = "name"
    values = ["Ubuntu 18.04 x64"]
  }
}

data "vultr_os" "ubuntu_20_04" {
  filter {
    name   = "name"
    values = ["Ubuntu 20.04 x64"]
  }
}

data "vultr_os" "ubuntu_20_10" {
  filter {
    name   = "name"
    values = ["Ubuntu 20.10 x64"]
  }
}

data "vultr_os" "debian_8_i386" {
  filter {
    name   = "name"
    values = ["Debian 8 i386 (jessie)"]
  }
}

data "vultr_os" "debian_9" {
  filter {
    name   = "name"
    values = ["Debian 9 x64 (stretch)"]
  }
}

data "vultr_os" "debian_10" {
  filter {
    name   = "name"
    values = ["Debian 10 x64 (buster)"]
  }
}

data "vultr_os" "freebsd_11" {
  filter {
    name   = "name"
    values = ["FreeBSD 11 x64"]
  }
}

data "vultr_os" "freebsd_12" {
  filter {
    name   = "name"
    values = ["FreeBSD 12 x64"]
  }
}

data "vultr_os" "openbsd_6_7" {
  filter {
    name   = "name"
    values = ["OpenBSD 6.7 x64"]
  }
}

data "vultr_os" "openbsd_6_8" {
  filter {
    name   = "name"
    values = ["OpenBSD 6.8 x64"]
  }
}

data "vultr_os" "fedora_coreos" {
  filter {
    name   = "name"
    values = ["Fedora CoreOS"]
  }
}

data "vultr_os" "fedora_32" {
  filter {
    name   = "name"
    values = ["Fedora 32 x64"]
  }
}

data "vultr_os" "fedora_33" {
  filter {
    name   = "name"
    values = ["Fedora 33 x64"]
  }
}

data "vultr_os" "windows_2012_r2" {
  filter {
    name   = "name"
    values = ["Windows 2012 R2 x64"]
  }
}

data "vultr_os" "windows_2016" {
  filter {
    name   = "name"
    values = ["Windows 2016 x64"]
  }
}

locals {
  os_ids = {
    centos_7: data.vultr_os.centos_7
    centos_7_selinux: data.vultr_os.centos_7_selinux
    centos_8: data.vultr_os.centos_8
    centos_8_stream: data.vultr_os.centos_8_stream
    ubuntu_16_04: data.vultr_os.ubuntu_16_04
    ubuntu_16_04_i386: data.vultr_os.ubuntu_16_04_i386
    ubuntu_18_04: data.vultr_os.ubuntu_18_04
    ubuntu_20_04: data.vultr_os.ubuntu_20_04
    ubuntu_20_10: data.vultr_os.ubuntu_20_10
    debian_8_i386: data.vultr_os.debian_8_i386
    debian_9: data.vultr_os.debian_9
    debian_10: data.vultr_os.debian_10
    freebsd_11: data.vultr_os.freebsd_11
    freebsd_12: data.vultr_os.freebsd_12
    openbsd_6_7: data.vultr_os.openbsd_6_7
    openbsd_6_8: data.vultr_os.openbsd_6_8
    fedora_coreos: data.vultr_os.fedora_coreos
    fedora_32: data.vultr_os.fedora_32
    fedora_33: data.vultr_os.fedora_33
    windows_2012_r2: data.vultr_os.windows_2012_r2
    windows_2016: data.vultr_os.windows_2016
  }
}

#########################
#                       #
#         PLANS         #
#                       #
#########################



data "vultr_plan" "vc2-1c-1gb" {
  filter {
    name   = "id"
    values = ["vc2-1c-1gb"]
  }
}

data "vultr_plan" "vc2-1c-2gb" {
  filter {
    name   = "id"
    values = ["vc2-1c-2gb"]
  }
}

data "vultr_plan" "vc2-2c-4gb" {
  filter {
    name   = "id"
    values = ["vc2-2c-4gb"]
  }
}

data "vultr_plan" "vc2-4c-8gb" {
  filter {
    name   = "id"
    values = ["vc2-4c-8gb"]
  }
}

data "vultr_plan" "vc2-6c-16gb" {
  filter {
    name   = "id"
    values = ["vc2-6c-16gb"]
  }
}

data "vultr_plan" "vc2-8c-32gb" {
  filter {
    name   = "id"
    values = ["vc2-8c-32gb"]
  }
}

data "vultr_plan" "vc2-16c-64gb" {
  filter {
    name   = "id"
    values = ["vc2-16c-64gb"]
  }
}

data "vultr_plan" "vc2-24c-96gb" {
  filter {
    name   = "id"
    values = ["vc2-24c-96gb"]
  }
}

locals {
  plan_ids = {
    vc2-1c-1gb: data.vultr_plan.vc2-1c-1gb
    vc2-1c-2gb: data.vultr_plan.vc2-1c-2gb
    vc2-2c-4gb: data.vultr_plan.vc2-2c-4gb
    vc2-4c-8gb: data.vultr_plan.vc2-4c-8gb
    vc2-6c-16gb: data.vultr_plan.vc2-6c-16gb
    vc2-8c-32gb: data.vultr_plan.vc2-8c-32gb
    vc2-16c-64gb: data.vultr_plan.vc2-16c-64gb
    vc2-24c-96gb: data.vultr_plan.vc2-24c-96gb
  }
}