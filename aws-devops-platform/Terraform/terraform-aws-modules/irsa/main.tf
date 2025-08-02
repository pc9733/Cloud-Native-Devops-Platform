resource "aws_iam_role" "my_app_irsa" {
  name = "eks-irsa-cloud-native-app"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = module.eks.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(module.eks.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:default:cloud-native-app"
        }
      }
    }]
  })

  tags = {
    Name = "eks-irsa-cloud-native-app"
  }
}

resource "aws_iam_role_policy_attachment" "my_app_irsa_attachment" {
  role       = aws_iam_role.my_app_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
