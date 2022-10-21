module "Grafana" {
    source = "./AMG"
    region = "ap-northeast-1"
    profile = "shubham"
    name = "Iaac-amg-workspace"  
    aws_iam_role_name = "Iaac-amg-workspace-role"
    account_access_type = "CURRENT_ACCOUNT"
    authentication_providers = ["AWS_SSO"]
    permission_type = "CUSTOMER_MANAGED"
    Admin_permission = "ADMIN"
    aws_iam_policy_name = "AMGWorkspaceRole_MVP_policy"
    account_id = [""]
}