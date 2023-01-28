resource "aws_vpc" "remote_dev_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Application = "VSCode dev environment"
    Environment = var.environment
    Resource    = "modules.environment.aws_vpc.remote_dev_vpc"
  }
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.remote_dev_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.remote_dev_vpc.cidr_block, 8, 1 + count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  count                   = 1

  tags = {
    Name        = "${var.environment}-vpc"
    Application = "VSCode dev environment"
    Environment = var.environment
    Resource    = "modules.environment.aws_vpc.crazy_vpc"
  }

}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.remote_dev_vpc.id

  tags = {
    Name        = "${var.environment}-igw"
    Application = "VSCode dev environment"
    Environment = var.environment
    Resource    = "modules.environment.aws_vpc.crazy_igw"
  }
}


resource "aws_route_table" "default_public_rt" {
  vpc_id = aws_vpc.remote_dev_vpc.id
  count  = 1

  tags = {
    Name        = "${var.environment}-public-rt"
    Application = "VSCode dev environment"
    Environment = var.environment
    Resource    = "modules.environment.aws_vpc.default_public_rt"
  }
}
resource "aws_route" "default_route" {
  count                  = 1
  route_table_id         = element(aws_route_table.default_public_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_internet_gateway.id

}

resource "aws_route_table_association" "default_public_assoc" {
  count          = 1
  subnet_id      = element(aws_subnet.main_public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.default_public_rt.*.id, count.index)
}
