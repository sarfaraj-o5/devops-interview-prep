dynamic "ingress" {
  for_each = var.rules
  content {
    from_port = ingress.value.from
    to_port   = ingress.value.to
  }
}
