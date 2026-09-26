resource "yandex_container_registry" "project1" {
  name      = "project1-registry"
  folder_id = var.folder_id
}

resource "yandex_container_repository" "project1_web" {
  name = "${yandex_container_registry.project1.id}/web"
}