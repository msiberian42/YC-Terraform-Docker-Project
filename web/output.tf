output "web_security_group_id" {
  description = "Web security group ID"
  value       = yandex_vpc_security_group.project1-web-security-group.id
}