resource "yandex_vpc_security_group" "project1-db-security-group" {
  name       = "project1-db-security-group"
  network_id = data.terraform_remote_state.vpc.outputs.network_id

  ingress {
    protocol          = "TCP"
    description       = "MySQL to web"
    port              = 3306
    security_group_id = yandex_vpc_security_group.project1-web-security-group.id
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow incoming ssh"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}