output "web_public_ip" {
  description = "Web VM static public IP"
  value = [
    for address in yandex_vpc_address.project1_web :
    address.external_ipv4_address[0].address
  ]
}