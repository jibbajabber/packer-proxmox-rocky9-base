source "proxmox-iso" "kickstart" {
  vm_id                    = "${var.vm_id}"
  vm_name                  = "${var.template_name}"
  boot_command             = [
    "<tab><wait>",
    " net.ifnames=0 biosdevname=0",
    " inst.noverifyssl",
    " ip=${var.ip_address}::${var.gateway}:${var.netmask}::eth0:off nameserver=${var.dns_server}",
    " inst.ks=http://${var.http_server_ip}:8425/default.ks<enter>"
  ]
  boot_wait                = "10s"
  cores                    = 2
  cpu_type                 = "host"
  memory                   = "4096"
  cloud_init               = true
  cloud_init_disk_type     = "sata"
  cloud_init_storage_pool  = "local-lvm"

  disks {
    disk_size    = "80G"
    storage_pool = "local-lvm"
    type         = "sata"
  }

  http_content             = {
    "/default.ks" = templatefile(
                      "${path.root}/ks/default.ks.pkrtpl",
                      { ip_address                = var.ip_address,
                        netmask                   = var.netmask,
                        gateway                   = var.gateway,
                        dns_server                = var.dns_server,
                        domain                    = var.domain,
                        template_name             = var.template_name,
                        root_pass_crypted         = var.root_crypted_pass,
                        automation_user           = var.automation_user,
                        automation_crypted_pass   = var.automation_crypted_pass,
                        automation_ssh_public_key = var.automation_ssh_public_key,
                        swap_config               = var.swap_config
                      }
                    )
  }
  http_port_min            = "${var.http_port}"
  http_port_max            = "${var.http_port}"
  insecure_skip_tls_verify = true
  boot_iso {
    iso_file = "local:iso/${var.rocky_9_iso_image_name}"
    unmount  = true
  }
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node                     = "${var.proxmox_node_name}"
  os                       = "l26"
  username                 = "${var.proxmox_user}"
  password                 = "${var.proxmox_pass}"
  proxmox_url              = "https://${var.proxmox_host}:8006/api2/json"
  ssh_username             = "root"
  ssh_password             = "${var.root_clear_pass}"
  ssh_timeout              = "20m"
  template_name            = "${var.template_name}"
  template_description     = "${var.template_name}, generated on ${timestamp()}"
}

build {
  sources = ["source.proxmox-iso.kickstart"]
  name    = "proxmox-rl9"

  provisioner "shell" {
    inline = [
      "yum install -y cloud-init cloud-utils-growpart gdisk qemu-guest-agent",
      "systemctl enable qemu-guest-agent",
      "systemctl enable cloud-init",
      "shred -u /etc/ssh/*_key /etc/ssh/*_key.pub",
      "rm -f /etc/sysconfig/network-scripts/ifcfg*",
      "rm -f /etc/NetworkManager/system-connections/*",
      "rm -f /etc/ssh/ssh_config.d/allow-root-ssh.conf",
      "cloud-init clean -l"
    ]
  }
}
