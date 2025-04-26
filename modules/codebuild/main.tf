locals {
  codebuild_projects = var.codebuild_projects

  codebuild_projectsset = {
    for project in [for project in local.codebuild_projects : project if project != null] :
    lower(project.codebuild_project_name) => project
  }
}

resource "aws_codebuild_webhook" "this" {
  for_each = { for k, v in local.codebuild_projectsset : k => v if var.create && var.create_webhook }

  branch_filter = lookup(each.value, "branch_filter", null)
  build_type    = lookup(each.value, "build_type", "BUILD")
  project_name  = aws_codebuild_project.this[each.key].name

  dynamic "filter_group" {
    for_each = [lookup(each.value, "filter_group", {})]

    content {
      dynamic "filter" {
        for_each = lookup(filter_group.value, "filter", null) == null ? [] : filter_group.value.filter

        content {
          exclude_matched_pattern = lookup(filter.value, "exclude_matched_pattern", false)
          pattern                 = filter.value["pattern"]
          type                    = filter.value["type"]
        }
      }
    }
  }
}


resource "aws_codebuild_project" "this" {
  for_each = { for k, v in local.codebuild_projectsset : k => v if var.create }

  name          = each.value.codebuild_project_name
  description   = each.value.description
  build_timeout = lookup(each.value, "build_timeout", "60")
  service_role  = each.value.service_role

  artifacts {
    type = "NO_ARTIFACTS"
  }

  dynamic "cache" {
    for_each = length(keys(lookup(each.value, "cache", {}))) == 0 ? [] : [each.value.cache]
    content {
      type  = lookup(cache.value, "type", "NO_CACHE")
      modes = lookup(cache.value, "modes", []) != [] && cache.value.type == "LOCAL" ? cache.value.modes : []
    }
  }

  dynamic "environment" {
    for_each = [lookup(each.value, "environment", {})]
    content {
      compute_type                = lookup(environment.value, "compute_type", "BUILD_GENERAL1_MEDIUM")
      image                       = lookup(environment.value, "image", "aws/codebuild/standard:4.0")
      image_pull_credentials_type = lookup(environment.value, "image_pull_credentials_type", "CODEBUILD")
      privileged_mode             = lookup(environment.value, "privileged_mode", false)
      type                        = lookup(environment.value, "type", "LINUX_CONTAINER")

      dynamic "environment_variable" {
        #for_each = length(keys(lookup(each.value, "environment_variable", {}))) == 0 ? [] : each.value.environment_variable
        for_each = lookup(environment.value, "environment_variable", null) == null ? [] : environment.value.environment_variable
        content {
          name  = environment_variable.value["name"]
          type  = environment_variable.value["type"]
          value = environment_variable.value["value"]
        }
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = each.value.codebuild_group_name
      stream_name = each.value.codebuild_stream_name
    }
  }

  source {
    location        = lookup(each.value, "location", null)
    buildspec       = each.value.codebuild_buildspec
    type            = lookup(each.value, "type", "NO_SOURCE")
    git_clone_depth = lookup(each.value, "git_clone_depth", 1)

    dynamic "git_submodules_config" {
      for_each = lookup(each.value, "git_submodules_config", null) == null ? [] : [each.value.git_submodules_config]
      content {
        fetch_submodules = lookup(git_submodules_config.value, "fetch_submodules", false)
      }
    }
  }

  dynamic "vpc_config" {
    for_each = length(keys(lookup(each.value, "vpc_config", {}))) == 0 ? [] : [each.value.vpc_config]
    content {
      security_group_ids = lookup(vpc_config.value, "security_group_ids", [])
      subnets            = lookup(vpc_config.value, "subnets", [])
      vpc_id             = lookup(vpc_config.value, "vpc_id")
    }
  }

  tags     = var.tags
  tags_all = var.tags
}
