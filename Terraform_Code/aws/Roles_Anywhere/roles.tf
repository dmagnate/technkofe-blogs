resource "aws_iam_role" "iam_role_infra" {
  name = "iam-roles-anywhere"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ]
      Principal = {
        Service = "rolesanywhere.amazonaws.com",
      }
      Effect = "Allow"
      Sid    = ""
      Condition = {
         "ArnEquals": { "aws:SourceArn": join("/", ["arn:aws:rolesanywhere:eu-west-2:330895451783:trust-anchor", aws_rolesanywhere_trust_anchor.ta_1.id ])
         }
      }
    }]
  })
}