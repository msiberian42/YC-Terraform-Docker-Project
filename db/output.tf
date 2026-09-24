output "database_id" {
  description = "DB ID"
  value       = yandex_compute_instance.db.id
}

output "database_ip" {
  description = "DB IP"
  value       = yandex_compute_instance.db.ip_address
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

output "db_user" {
  description = "User"
  value       = var.db_user
}