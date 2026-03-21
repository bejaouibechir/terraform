variable "aws_region" {
  description = "Région AWS dans laquelle les resources seront créées"
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Nom de l'ingénieur qui crée les resources"
  type        = string
  default     = "Venkatesh"
}

# CIDR différent par environnement (workspace)
variable "vpc_cidr" {
  description = "CIDR du VPC par environnement"
  type        = map(string)
  default = {
    default = "10.0.0.0/16"
    dev     = "10.1.0.0/16"
    staging = "10.2.0.0/16"
    prod    = "10.3.0.0/16"
  }
}
