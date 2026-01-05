# Rocky9 base proxmox packer
Builds base rocky9 proxmox VM template with packer

## Prerequisites
* Proxmox VE installed environment
* Rocky9 minimal iso available as an iso image from your proxmox server

## Variables
### Required
* `proxmox_host`             : proxmox ip or fqdn
* `proxmox_node_name`        : proxmox node to deploy this template to
* `proxmox_user`             : proxmox user e.g `root@pam`
* `proxmox_pass`             : proxmox user password
* `ip_address`               : ip address of template to use
* `gateway`                  : gateway
* `netmask`                  : subnet mask
* `dns_server`               : dns server
* `domain`                   : domain for this vm template e.g `my-lab.example`
* `root_clear_pass`          : vm template root password
* `root_crypted_pass`        : `root_clear_pass` sha512 crypted password e.g `openssl passwd -6`
* `automation_crypted_pass`  : automation user sha512 crypted password
* `automation_ssh_public_key`: ssh public key content to authorise access for automation user
* `http_server_ip`           : http server ip (likely the ip of the machine this is called from), to serve the kickstart
* `swap_config`              : swap config to set, defaults to `part swap --size=4096`, set to empty string to disable swap

### Optional (defaults pre-set)
* `vm_id`                    : defaults to `9000`
* `template_name`            : defaults to `packer-rocky9-base-template`, vm template name
* `http_port`                : defaults to `8425`, kickstart http port
* `rocky_9_iso_image_name`   : defaults to `Rocky-9.6-x86_64-minimal.iso`, iso filename
                               uploaded to proxmox node iso images
* `automation_user`          : defaults to `ansible`, automation user to create

## Usage
Use `user-variables.pkvars.hcl.example` to create a new `user-variables.pkvars.hcl` file,
 replacing the values for your environment

Packer with docker was the simplest configuration for my environment, example docker packer cli:
```shell
$ docker run -it \
             -p <HTTP-PORT>:<HTTP-PORT> \
             --rm \
             --name packer \
             --entrypoint ''\
             -v ${PWD}:/data \
             -w /data \
             hashicorp/packer \
             bash
```

### Build template
```shell
$ packer init .

# Build with defaults
$ packer validate -var-file=user-variables.pkrvars.hcl .
$ packer build -var-file=user-variables.pkrvars.hcl .

# Build with changes to swap
$ packer validate -var-file=user-variables.pkrvars.hcl -var vm_id=9010 -var template_name=packer-rocky9-noswap-base-template -var swap_config='' .
$ packer build -var-file=user-variables.pkrvars.hcl -var vm_id=9010 -var template_name=packer-rocky9-noswap-base-template -var swap_config='' . 
```

## Notes
* disk type needed to be set as `sata` for my personal environment with proxmox node storage that has nvme and lvm setup
