variable "proxmox_host" {
  type = string
  description = "proxmox host"
}
variable "proxmox_node_name" {
    type = string
    description = "proxmox node name"
}
variable "proxmox_user" {
    type = string
    description = "proxmox user"
}
variable "proxmox_pass" {
    type = string
    description = "proxmox password"
}

variable "ip_address" {
  type        = string
  description = "template ip address"
}
variable "gateway" {
  type        = string
  description = "gateway"
}
variable "netmask" {
  type        = string
  description = "subnet mask"
}
variable "dns_server" {
  type        = string
  description = "dns server"
}
variable "domain" {
  type        = string
  description = "domain"
}

variable "root_clear_pass" {
  type        = string
  description = "root password"
}
variable "root_crypted_pass" {
  type        = string
  description = "crypted root password for kickstart"
}
variable "automation_crypted_pass" {
  type        = string
  description = "kickstart crypted automation password"
}
variable "automation_ssh_public_key" {
  type        = string
  description = "automation ssh public key to authorise access"
}

variable "vm_id" {
  type        = number
  description = "vm id"
  default     = 9000
}

variable "template_name" {
  type        = string
  description = "vm template name"
  default     = "packer-rocky9-base-template"
}

variable "http_server_ip" {
  type        = string
  description = "kickstart http server ip"
}
variable "http_port" {
  type        = number
  description = "kickstart http port"
  default     = 8425
}

variable "rocky_9_iso_image_name" {
  type        = string
  description = "rocky 9 iso image name"
  default     = "Rocky-9.6-x86_64-minimal.iso"
}

variable "automation_user" {
  type        = string
  description = "automation username"
  default     = "ansible"
}

variable "swap_config" {
  type        = string
  description = "swap kickstart content, set to empty string to disable swap"
  default     = "part swap --size=4096"
}
