resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = merge(var.tags, {
    Name = lookup(var.tags, "Name", "module-ec2")
  })
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${lookup(var.tags, "Name", "module-ec2")}-eip"
  })
}

