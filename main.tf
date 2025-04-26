locals {
  create_codepipeline_project = var.create
}

resource "aws_codepipeline" "this" {
  count = local.create_codepipeline_project ? 1 : 0

  pipeline_type = var.pipeline_type
  name          = var.codepipeline_project_name
  role_arn      = var.codepipeline_role_arn

  artifact_store {
    location = var.codepipeline_artifact_store
    type     = "S3"
  }

  dynamic "variable" {
    for_each = [for variable in var.codepipeline_variables : variable if variable != {}]
    content {
      default_value = variable.value["default_value"]
      description   = variable.value["description"]
      name          = variable.value["name"]
    }
  }

  dynamic "stage" {
    #for_each = var.codepipeline_stages # != null ? [var.codepipeline_stages] : []
    #for_each = [for stage in var.codepipeline_stages : stage if stage != null] #var.codepipeline_stages
    for_each = [for stage in var.codepipeline_stages : stage if stage != null]

    content {
      #name = stage.value.name
      name = lookup(stage.value, "name")
      dynamic "action" {
        #for_each = length(keys(stage.value.action)) > 0 ? stage.value.action : [] #codepipeline_stages.value["action"] #lookup(stage.value, "action", {})
        #for_each = stage.value.action
        #for_each = length(keys(stage.value.action)) > 0 ? stage.value.action : []
        for_each = [for action in stage.value.action : action if action != null]
        content {
          category = lookup(action.value, "category", null)
          name     = lookup(action.value, "name", null)
          owner    = lookup(action.value, "owner", null)
          provider = lookup(action.value, "provider", null)
          version  = lookup(action.value, "version", null)

          input_artifacts  = lookup(action.value, "input_artifacts", [])
          output_artifacts = lookup(action.value, "output_artifacts", [])
          namespace        = lookup(action.value, "namespace", null)
          configuration    = lookup(action.value, "configuration", null)
          run_order        = lookup(action.value, "run_order", 1)
          region           = lookup(action.value, "region", null)
        }
      }
    }
  }

  dynamic "trigger" {
    for_each = length(keys(var.trigger)) != 0 && var.pipeline_type == "V2" ? [var.trigger] : []

    content {
      provider_type = lookup(trigger.value, "provider_type", "CodeStarSourceConnection")

      dynamic "git_configuration" {
        for_each = length(keys(lookup(trigger.value, "git_configuration", {}))) == 0 ? [] : [trigger.value.git_configuration]

        content {
          source_action_name = lookup(git_configuration.value, "source_action_name", "Source")

          dynamic "push" {
            for_each = length(keys(lookup(git_configuration.value, "push", {}))) == 0 ? [] : [git_configuration.value.push]

            content {
              dynamic "branches" {
                for_each = length(keys(lookup(push.value, "branches", {}))) == 0 ? [] : [push.value.branches]

                content {
                  includes = lookup(branches.value, "includes", null)
                  excludes = lookup(branches.value, "excludes", null)
                }
              }
            }
          }
        }
      }
    }
  }

  tags     = var.tags
  tags_all = var.tags
}
