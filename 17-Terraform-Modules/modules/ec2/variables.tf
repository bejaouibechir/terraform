variable "ami_id" {
  description = "AMI ID used to launch the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance is launched."
  type        = string
}

variable "tags" {
  description = "Tags applied to EC2 resources."
  type        = map(string)
  default     = {}
}

