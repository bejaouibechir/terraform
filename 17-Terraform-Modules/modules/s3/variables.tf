variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "versioning_enabled" {
  description = "Whether S3 bucket versioning is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to S3 resources."
  type        = map(string)
  default     = {}
}

