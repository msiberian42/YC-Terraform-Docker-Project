output "network_id" {
  description = "VPC net ID"
  value       = yandex_vpc_network.vpc_list.id
}

output "subnets" {
  description = "VPC subnets"
  value       = yandex_vpc_subnet.vpc_list
}