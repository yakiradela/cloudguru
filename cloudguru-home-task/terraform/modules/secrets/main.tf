variable "secrets" {
  type = map(string)
}

resource "aws_secretsmanager_secret" "app_secrets" {
  for_each = var.secrets

  name = each.key
}

resource "aws_secretsmanager_secret_version" "secrets_version" {
  for_each        = var.secrets

  secret_id       = aws_secretsmanager_secret.app_secrets[each.key].id
  secret_string   = each.value
}
