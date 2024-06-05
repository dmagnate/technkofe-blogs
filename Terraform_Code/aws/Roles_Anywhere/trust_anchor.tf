provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "my-state"
    key    = "iam_roles_anywhere.tfstate"
    region = "eu-west-2"
  }
}


data "aws_partition" "current" {}

resource "aws_acmpca_certificate" "ra_1" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.private_it_root_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.private_it_root_ca.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 1
  }
}

resource "aws_acmpca_certificate_authority_certificate" "cert_1" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_it_root_ca.arn
  certificate               = aws_acmpca_certificate.ra_1.certificate
  certificate_chain         = aws_acmpca_certificate.ra_1.certificate_chain
}

resource "aws_rolesanywhere_trust_anchor" "ta_1" {
  name = "trust_anchor_private"
  enabled = true

#### Option 1 If using AWS Hosted Private CA
  source {
    source_data {
      acm_pca_arn = aws_acmpca_certificate_authority.example.arn
    }
    source_type = "AWS_ACM_PCA"
  }
#### Option 2 If using private self hosted CA, provide root certificate in .pem format to create trust anchor
#   source {
#     source_data {
#       x509_certificate_data = file("server.pem")
#     }
#     source_type = "CERTIFICATE_BUNDLE"
#   }
  tags = var.tags
  # Wait for the ACMPCA to be ready to receive requests before setting up the trust anchor
  depends_on = [aws_acmpca_certificate_authority_certificate.cert_1]
}