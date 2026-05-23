output "public_ip" {
  description = "Public IP address allocated to the EC2 instance."
  value       = aws_eip.this.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

