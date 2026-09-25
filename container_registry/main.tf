resource "yandex_container_registry" "project1" {
  name      = "project1-registry"
  folder_id = var.folder_id
}

resource "yandex_container_repository" "project1_web" {
  name = "${yandex_container_registry.project1.id}/web"
}

# resource "yandex_iam_service_account" "project1_web" {
#   name      = "project1-web"
#   folder_id = var.folder_id
# }

# resource "yandex_resourcemanager_folder_iam_member" "project1_web_puller" {
#   folder_id = var.folder_id
#   role      = "container-registry.images.puller"
#   member    = "serviceAccount:${yandex_iam_service_account.project1_web.id}"
# }

# resource "yandex_lockbox_secret_iam_member" "project1_web_payload_viewer" {
#   secret_id = data.terraform_remote_state.lockbox..outputs.lockbox_id
#   role      = "lockbox.payloadViewer"

#   member = "serviceAccount:${yandex_iam_service_account.project1_web.id}"
# }