resource "yandex_lockbox_secret" "project1_db" {
  name        = "project1-db"
  description = "Credentials for MySQL"
  folder_id   = var.folder_id

   password_payload_specification {
    password_key        = "password"
    length              = 16
    include_uppercase   = true
    include_lowercase   = true
    include_digits      = true
    include_punctuation = true
  }
}

# resource "random_password" "db_password" {
#   length  = 16
#   special = true
# }

resource "yandex_lockbox_secret_version_hashed" "project1_db" {
  secret_id = yandex_lockbox_secret.project1_db.id

  #   key_1        = "password"
  #   text_value_1 = random_password.db_password.result
}