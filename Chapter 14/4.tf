#modules/vpc/main.tf
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = { Name = var.name }
}

resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = var.subnet_name }
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = aws_subnet.this.id
}

#modules/ec2/main.tf
variable "subnet_id" {
  description = "The ID of the subnet to deploy instances into"
  type        = string
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  tags = { Name = "web-server" }
}

# Main.tf
# Root configuration
module "network" {
  source     = "./modules/vpc"
  name       = "example-vpc"
  cidr_block = "10.0.0.0/16"
}

module "compute" {
  source         = "./modules/ec2"
  subnet_id         = module.network.subnet_id
  ami_id         = "ami-0abcdef1234567890"
  instance_type  = "t3.micro"
  subnet_cidr    = "10.0.1.0/24"
}
