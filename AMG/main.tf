resource "aws_grafana_workspace" "grafanaworkspace" {
  name                     = var.name
  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type
  role_arn                 = aws_iam_role.AMGWorkspaceRole_MVP.arn
  #name                     = var.grafana_workspacename
  tags    = {
    Name = var.name
  }
}


resource "aws_grafana_workspace_api_key" "key" {
  key_name        = "admin"
  key_role        = var.Admin_permission
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.grafanaworkspace.id
}



##Cross account iam role###
resource "aws_iam_role" "AMGWorkspaceRole_MVP" {
  name = var.aws_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "AMGWorkspaceRole_MVP_policy" {
  name        = var.aws_iam_policy_name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0",
        Action = "sts:AssumeRole",
        Effect   = "Allow",
        Resource = [
          "arn:aws:iam::${var.account_id[0]}:role/AMGCloudWatchDataSourceRole",
          "arn:aws:iam::${var.account_id[1]}:role/AMGPrometheusDataSourceRole",
          "arn:aws:iam::${var.account_id[2]}:role/AMGCloudWatchDataSourceRole",
          "arn:aws:iam::${var.account_id[3]}:role/AMGPrometheusDataSourceRole",
          "arn:aws:iam::${var.account_id[4]}:role/AMGCloudWatchDataSourceRole",
          "arn:aws:iam::${var.account_id[5]}:role/AMGPrometheusDataSourceRole",
          "arn:aws:iam::${var.account_id[6]}:role/AMGCloudWatchDataSourceRole"
        ]
      },
    ]
  })
}

##Policy attachment######

resource "aws_iam_policy_attachment" "AMGWorkspaceRole_MVP_policyattachment" {
  name = "demo"
  roles      = [aws_iam_role.AMGWorkspaceRole_MVP.name]
  policy_arn = aws_iam_policy.AMGWorkspaceRole_MVP_policy.arn
}

output "namespace" {
  value = aws_grafana_workspace.grafanaworkspace.name
}