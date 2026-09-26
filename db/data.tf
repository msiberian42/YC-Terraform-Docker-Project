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

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "project1-terraform-bucket"
    key    = "security/terraform.tfstate"
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

data "terraform_remote_state" "lockbox" {
  backend = "s3"

  config = {
    bucket = "project1-terraform-bucket"
    key    = "lockbox/terraform.tfstate"
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

data "template_file" "db-init" {
  template = file("${path.module}/db-init.yml")

  vars = {
    db_name              = var.db_name
    db_user              = var.db_user
    db_lockbox_secret_id = data.terraform_remote_state.lockbox.outputs.lockbox_id
  }
}