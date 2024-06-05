# resource "aws_acm_certificate" "bookstack_cert" {
#   domain_name       = "bookstack.amzn.featurespace.net"
#   certificate_authority_arn = aws_acmpca_certificate_authority.private_it_root_ca.arn

#   tags = var.tags

#   lifecycle {
#     create_before_destroy = true
#   }
# }
