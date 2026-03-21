variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Nom du VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR du Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zone de disponibilité AWS"
  type        = string
  default     = "us-east-1a"
}
