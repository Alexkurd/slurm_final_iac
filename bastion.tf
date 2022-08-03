resource "yandex_compute_instance" "bastion" {
  name                      = "bastion"
  hostname                  = "bastion"
  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = "fd8qps171vp141hl7g9l" # Ubuntu LTS 20.04
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.s041120.id
    ip_address = "10.5.0.254"
    nat        = true
  }
  metadata = {
    user-data          = data.cloudinit_config.bastion.rendered
    ssh-keys           = "ubuntu:${var.public_key}"
    serial-port-enable = "1" #web-console
  }
}

locals {
  yc_config = base64encode(templatefile("${path.module}/cloud-init/config.yc.tftpl",
  { yc_token = var.yc_token, cloud_id = var.cloud_id, folder_id = var.folder_id }))
  bastion_init = file("${path.module}/cloud-init/init.sh")
  cloud_config = replace(file("${path.module}/cloud-init/bastion-cloud-config.yaml"), "YC_CONFIG", local.yc_config)
}

data "cloudinit_config" "bastion" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = local.cloud_config
    filename     = "cloud-config.yaml"
  }
  part {
    content_type = "text/x-shellscript-per-once"
    content      = local.bastion_init
    filename     = "once.sh"
  }
}