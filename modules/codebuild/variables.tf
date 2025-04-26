variable "codebuild_projects" {
  description = "The CodeBuild projects to create."
  type        = any
}

variable "create" {
  description = "Set to true to create the CodeBuild project."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the CodeBuild project."
  type        = map(string)
  default     = {}
}

variable "create_webhook" {
  description = "Set to true to create a webhook for the CodeBuild project."
  type        = bool
  default     = false
}
