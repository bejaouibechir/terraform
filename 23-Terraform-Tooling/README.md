# Terraform Tooling

This module introduces the quality and security tools commonly used around Terraform codebases.

## Tools

| Tool | Purpose | Typical command |
| ---- | ------- | --------------- |
| `terraform fmt` | Rewrites Terraform files into the canonical HCL style. | `terraform fmt -recursive` |
| `terraform validate` | Checks whether the configuration is syntactically valid and internally consistent. | `terraform validate` |
| `tflint` | Detects provider-specific issues and Terraform style problems before deployment. | `tflint --init && tflint` |
| `checkov` | Scans Terraform code for security and compliance risks. | `checkov -d . --framework terraform` |

## Demo Flow

The file `01_vpc.tf` is intentionally misformatted so `terraform fmt` has a visible effect.

```bash
terraform fmt -recursive
terraform validate
tflint --init && tflint
checkov -d . --framework terraform
```

## Prerequisites

- Terraform `>= 1.5`
- TFLint with the AWS plugin
- Checkov
- AWS credentials provided by environment variables when running against AWS

No credentials are stored in this module.

