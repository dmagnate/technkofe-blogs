resource "aws_acm_certificate" "private_cert" {
  domain_name       = "server-cert.technokofe.com"
  certificate_authority_arn = aws_acmpca_certificate_authority.private_it_root_ca.arn

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
