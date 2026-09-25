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