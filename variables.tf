variable "create" {
  type        = bool
  description = "Set to true to create the CodePipeline project."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the CodePipeline project."
  default     = {}
}

variable "codepipeline_project_name" {
  description = "The name of the CodePipeline project."
  type        = string
}

variable "codepipeline_role_arn" {
  description = "The ARN of the IAM role that CodePipeline assumes to perform actions on your behalf."
  type        = string
}

variable "codepipeline_artifact_store" {
  description = "The S3 bucket where CodePipeline stores artifacts."
  type        = string
}

#variable "codepipeline_stages" {
#  type = list(object(
#    {
#      name = string
#      action = list(object(
#        {
#          category         = string       #null
#          name             = string       #null
#          owner            = string       #null
#          provider         = string       #null
#          version          = number       #null
#          input_artifacts  = list(string) #[]
#          output_artifacts = list(string) #[]
#          namespace        = string       #null
#          configuration    = map(string)  #{}
#          run_order        = number       #1
#          region           = string       #"us-east-1"
#        }
#        )
#      )
#    }
#  ))
#  default = null
#}

variable "codepipeline_stages" {
  description = "The stages of the CodePipeline project."
  type        = any
  default     = null
}

variable "pipeline_type" {
  description = "The type of the pipeline. Can be either V1 or V2."
  type        = string
  default     = "V1"
}

variable "codepipeline_variables" {
  description = "The variables for the CodePipeline project."
  type        = list(any)
  default     = []
}

variable "trigger" {
  description = "The trigger configuration for the pipeline."

  type = any #object({}) - if object it can't open to last values like branches

  # type = object({
  #   provider_type = string
  #   git_configuration = object({
  #     source_action_name = string
  #     push = object({
  #       branches = object({
  #         includes = list(string)
  #         excludes = optional(list(string))
  #       })
  #     })
  #   })
  # })

  default = {}
}
