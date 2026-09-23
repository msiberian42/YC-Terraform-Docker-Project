# Common variables
variable "ssh_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "serial_port_enable" {
  type    = number
  default = 1
}

variable "vm_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "vm_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "db_vm_name" {
  type        = string
  description = "DB VM name"
}

# VM resources
variable "vms_resources" {
  type = map(object({
    cores         = number,
    memory        = number,
    core_fraction = number,
    size          = number,
    preemptible   = bool,
    nat           = bool
  }))

  default = {
    db = {
      cores         = 4,
      memory        = 4,
      core_fraction = 20,
      size          = 15,
      preemptible   = true,
      nat           = true
    }
  }
}