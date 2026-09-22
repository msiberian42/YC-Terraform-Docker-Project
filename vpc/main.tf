resource "yandex_vpc_network" "vpc_list" {
  name = var.env_name
}

resource "yandex_vpc_subnet" "vpc_list" {
  for_each = {
    for subnet in var.subnets : subnet.zone => subnet
  }

  name           = "${var.env_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc_list.id
  v4_cidr_blocks = [each.value.cidr]
}