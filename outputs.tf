output "codepipeline_name" {
  description = "The name of the CodePipeline project."
  value       = one(aws_codepipeline.this[*].name)
}
