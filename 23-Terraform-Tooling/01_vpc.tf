resource "aws_vpc" "tooling_demo" {
cidr_block="10.23.0.0/16"
tags={
Name="tooling-demo-vpc"
Environment="demo"
}
}

