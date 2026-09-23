data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "project1-terraform-bucket"
    key    = "vpc/terraform.tfstate"
    region = "ru-central1"

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

resource "yandex_compute_instance" "web" {
  count    = var.web_vm_count
  name     = "project1-web-${count.index + 1}"
  hostname = "project1-web-${count.index + 1}"

  platform_id = var.vm_platform_id

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["web"].size
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["web"].preemptible
  }
  network_interface {
    subnet_id          = data.terraform_remote_state.vpc.outputs.subnets["ru-central1-a"].id
    nat                = var.vms_resources["web"].nat
    security_group_ids = [yandex_vpc_security_group.project1-web-security-group.id]
  }

  metadata = {
    serial-port-enable = tostring(var.serial_port_enable)
    ssh-keys           = "ubuntu:${var.ssh_key}"
  }
}