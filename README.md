<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.93 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.93 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codepipeline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codepipeline_artifact_store"></a> [codepipeline\_artifact\_store](#input\_codepipeline\_artifact\_store) | The S3 bucket where CodePipeline stores artifacts. | `string` | n/a | yes |
| <a name="input_codepipeline_project_name"></a> [codepipeline\_project\_name](#input\_codepipeline\_project\_name) | The name of the CodePipeline project. | `string` | n/a | yes |
| <a name="input_codepipeline_role_arn"></a> [codepipeline\_role\_arn](#input\_codepipeline\_role\_arn) | The ARN of the IAM role that CodePipeline assumes to perform actions on your behalf. | `string` | n/a | yes |
| <a name="input_codepipeline_stages"></a> [codepipeline\_stages](#input\_codepipeline\_stages) | The stages of the CodePipeline project. | `any` | `null` | no |
| <a name="input_codepipeline_variables"></a> [codepipeline\_variables](#input\_codepipeline\_variables) | The variables for the CodePipeline project. | `list(any)` | `[]` | no |
| <a name="input_create"></a> [create](#input\_create) | Set to true to create the CodePipeline project. | `bool` | `false` | no |
| <a name="input_pipeline_type"></a> [pipeline\_type](#input\_pipeline\_type) | The type of the pipeline. Can be either V1 or V2. | `string` | `"V1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the CodePipeline project. | `map(string)` | `{}` | no |
| <a name="input_trigger"></a> [trigger](#input\_trigger) | The trigger configuration for the pipeline. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codepipeline_name"></a> [codepipeline\_name](#output\_codepipeline\_name) | The name of the CodePipeline project. |
<!-- END_TF_DOCS -->
