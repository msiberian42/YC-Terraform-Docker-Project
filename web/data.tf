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

data "terraform_remote_state" "container-registry" {
  backend = "s3"

  config = {
    bucket = "project1-terraform-bucket"
    key    = "registry/terraform.tfstate"
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

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "project1-terraform-bucket"
    key    = "db/terraform.tfstate"
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

data "template_file" "web-init" {
  template = file("${path.module}/web-init.yml")

  vars = {
    db_host     = data.terraform_remote_state.db.outputs.database_ip
    db_name     = data.terraform_remote_state.db.outputs.db_name
    db_user     = data.terraform_remote_state.db.outputs.db_user
    db_password = var.db_password

    web_image = "cr.yandex/${data.terraform_remote_state.container-registry.web_repository}:v1"

    compose_yaml = file("${path.module}/app/compose.yaml")

    haproxy_cfg = file(
      "${path.module}/app/haproxy/reverse/haproxy.cfg"
    )

    nginx_default_conf = file(
      "${path.module}/app/nginx/ingress/default.conf"
    )

    nginx_conf = file(
      "${path.module}/app/nginx/ingress/nginx.conf"
    )
  }
}