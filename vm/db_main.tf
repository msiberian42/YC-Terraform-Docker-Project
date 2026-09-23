resource "yandex_compute_instance" "db" {
  for_each = {
    for vm in var.db_variables : vm.vm_name => vm
  }

  name     = each.value.vm_name
  hostname = each.value.vm_name

  platform_id = var.vm_platform_id
  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.size
    }
  }
  scheduling_policy {
    preemptible = each.value.preemptible
  }
  network_interface {
    subnet_id          = data.terraform_remote_state.vpc.outputs.subnets["ru-central1-a"].id
    nat                = each.value.nat
    security_group_ids = [yandex_vpc_security_group.project1-web-security-group.id]
  }

  metadata = {
    serial-port-enable = tostring(var.serial_port_enable)
    ssh-keys           = "ubuntu:${var.ssh_key}"
  }
}