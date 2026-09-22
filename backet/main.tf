# Сервисный аккаунт для Terraform remote state
resource "yandex_iam_service_account" "terraform_state" {
  name        = var.service_account_name
  description = "Service account for Terraform remote state"
}

# Права сервисного аккаунта на работу с Object Storage
resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform_state.id}"
}

# Static access key
resource "yandex_iam_service_account_static_access_key" "terraform_state" {
  service_account_id = yandex_iam_service_account.terraform_state.id
  description        = "Static access key for Terraform remote state"
}

# S3 bucket
resource "yandex_storage_bucket" "terraform_state" {
  bucket = var.bucket_name

  access_key = yandex_iam_service_account_static_access_key.terraform_state.access_key
  secret_key = yandex_iam_service_account_static_access_key.terraform_state.secret_key

  versioning {
    enabled = true
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.storage_admin
  ]
}