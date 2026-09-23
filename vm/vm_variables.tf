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

# VM count
variable "web_vm_count" {
  type        = number
  default     = 2
  description = "web VM count"
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
    web = {
      cores         = 2,
      memory        = 2,
      core_fraction = 20,
      size          = 12,
      preemptible   = true,
      nat           = true
    }
  }
}

# DB resources
variable "db_variables" {
  type = list(object({
    vm_name       = string,
    cores         = number,
    memory        = number,
    size          = number,
    core_fraction = number,
    preemptible   = bool,
    nat           = bool
  }))

  default = [{
    vm_name       = "main",
    cores         = 4,
    memory        = 4,
    size          = 15,
    core_fraction = 15,
    preemptible   = true,
    nat           = true
    },
    {
      vm_name       = "replica",
      cores         = 4,
      memory        = 4,
      size          = 15,
      core_fraction = 15,
      preemptible   = true,
      nat           = true
  }]
}