resource "yandex_compute_instance" "web" {
  count    = var.web_vm_count
  name     = "project1-web-${count.index + 1}"
  hostname = "project1-web-${count.index + 1}"

  platform_id        = var.vm_platform_id
  service_account_id = yandex_iam_service_account.project1_web.id

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
    security_group_ids = [data.terraform_remote_state.security.outputs.web_security_group_id]
  }

  metadata = {
    user-data          = data.template_file.web-init.rendered
    serial-port-enable = tostring(var.serial_port_enable)
    ssh-keys           = "ubuntu:${var.ssh_key}"
  }

  depends_on = [
    yandex_lockbox_secret_iam_member.project1_web_payload_viewer
  ]
}

resource "yandex_iam_service_account" "project1_web" {
  name      = "project1-web"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "project1_web_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.project1_web.id}"
}

resource "yandex_lockbox_secret_iam_member" "project1_web_payload_viewer" {
  secret_id = data.terraform_remote_state.lockbox.outputs.lockbox_id
  role      = "lockbox.payloadViewer"

  member = "serviceAccount:${yandex_iam_service_account.project1_web.id}"
}