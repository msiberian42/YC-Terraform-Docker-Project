resource "yandex_compute_instance" "db" {
  name     = var.db_vm_name
  hostname = var.db_vm_name

  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["db"].size
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["db"].preemptible
  }
  network_interface {
    subnet_id          = data.terraform_remote_state.vpc.outputs.subnets["ru-central1-a"].id
    nat                = var.vms_resources["db"].nat
    security_group_ids = [yandex_vpc_security_group.project1-db-security-group.id]
  }

  metadata = {
    user-data          = data.template_file.db-init.rendered
    serial-port-enable = tostring(var.serial_port_enable)
    ssh-keys           = "ubuntu:${var.ssh_key}"
  }
}