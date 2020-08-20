terraform {
  required_version = ">= 0.12.21"
}

module "openstack" {
  source = "./openstack"

  cluster_name = "beegfs_test"
  domain       = "calculquebec.cloud"
  image        = "CentOS-7-x64-2019-07"
  nb_users     = 10

  instances = {
    mgmt  = { type = "c4-15gb-205", count = 1 },
    login = { type = "p1-0.75gb", count = 1 },
    node  = [
      { type = "c2-3.75gb-92", count = 8 },
    ]
  }

  storage = {
    type         = "nfs"
    home_size    = 10
    project_size = 5
    scratch_size = 5
  }

  public_keys = [file("~/.ssh/id_rsa.pub")]

  # Shared password, randomly chosen if blank
  guest_passwd = ""

  # OpenStack specific
  os_floating_ips = []
}

output "sudoer_username" {
  value = module.openstack.sudoer_username
}

output "guest_usernames" {
  value = module.openstack.guest_usernames
}

output "guest_passwd" {
  value = module.openstack.guest_passwd
}

output "public_ip" {
  value = module.openstack.ip
}
