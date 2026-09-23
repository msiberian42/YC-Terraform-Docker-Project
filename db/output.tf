output "database_id" {
  description = "DB ID"
  value       = yandex_compute_instance.db.id
}

output "user_id" {
  description = "User ID"
  value       = var.db_user
}