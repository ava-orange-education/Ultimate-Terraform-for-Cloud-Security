#modules/vpc/main.tf
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags       = { Name = var.name }
}

resource "aws_subnet" "this" {
  for_each    = { for s in var.subnet_specs : s.name => s }
  vpc_id      = aws_vpc.this.id
  cidr_block  = each.value.cidr
  map_public_ip_on_launch = (each.key == "public")
  tags       = { Name = "${var.name}-${each.key}" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-igw" }
}

resource "aws_eip" "nat" {
  count = length([for s in var.subnet_specs : s if s.name == "public"])
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  for_each     = { for s in var.subnet_specs : s.name => s if s.name == "public" }
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.this[each.key].id
  tags          = { Name = "${var.name}-nat-${each.key}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-public-rt" }
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-private-rt" }
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat["public"].id
  }
}

resource "aws_route_table_association" "assoc" {
  for_each       = aws_subnet.this
  subnet_id      = each.value.id
  route_table_id = contains(["public"], each.key)
    ? aws_route_table.public.id
    : aws_route_table.private.id
}

# modules/vpc/variables.tf
variable "name" {
    type = string
    description = "Name prefix for the VPC resources"
}

variable "cidr_block" {
    type = string
    description = "CIDR block for the VPC"
}

variable "subnet_specs" {
  type = list(object({
    name = string
    cidr = string
  }))
  description = "Name and CIDR for subnet"
}

# modules/vpc/main.tf
output "vpc_id" {
  value = aws_vpc.this.id
}

// main.tf - usage in root module
module "network" {
  source       = "./modules/vpc"
  name         = "prod-vpc"
  cidr_block   = "10.0.0.0/16"
  subnet_specs = [
    { name = "public",  cidr = "10.0.1.0/24" },
    { name = "private", cidr = "10.0.2.0/24" }
  ]
}
