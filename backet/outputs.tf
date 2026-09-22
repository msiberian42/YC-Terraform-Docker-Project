output "bucket_name" {
  description = "Name of the Terraform state bucket"
  value       = yandex_storage_bucket.terraform_state.bucket
}

output "access_key_id" {
  description = "Static access key ID"
  value       = yandex_iam_service_account_static_access_key.terraform_state.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Static secret key"
  value       = yandex_iam_service_account_static_access_key.terraform_state.secret_key
  sensitive   = true
}

output "backend_config" {
  description = "Terraform S3 backend configuration"
  sensitive   = true

  value = <<-EOT
terraform {
  backend "s3" {
    bucket = "${yandex_storage_bucket.terraform_state.bucket}"
    key    = "terraform.tfstate"
    region = "ru-central1"

    use_lockfile = true

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
EOT
}