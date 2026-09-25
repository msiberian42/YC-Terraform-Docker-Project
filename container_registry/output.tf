output "container_registry_id" {
  value = yandex_container_registry.project1.id
}

output "web_repository" {
  value = yandex_container_repository.project1_web.name
}

output "web_image_repository" {
  value = "cr.yandex/${yandex_container_repository.project1_web.name}"
}

# output "web_service_account_id" {
#   value = yandex_iam_service_account.project1_web.id
# }