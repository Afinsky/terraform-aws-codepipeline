output "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  value       = { for k, v in aws_codebuild_project.this : k => v.name }
}

output "codebuild_project_arn" {
  description = "The ARN of the CodeBuild project"
  value       = { for k, v in aws_codebuild_project.this : k => v.arn }
}

output "webhook_payload_url" {
  description = "The payload URL of the webhook"
  value       = { for k, v in aws_codebuild_webhook.this : k => v.payload_url }
}
