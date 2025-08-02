resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
      Name = "${var.project_name}-vpc-1"
    }
}
resource "aws_subnet" "subnet-public" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet)
  subnet_id      = aws_subnet.subnet-public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "subnet-private" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.availability_zone[count.index]
  
  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0


  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.subnet-public[0].id

  tags = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_route_table" "private" {
 
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
  
}
resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0
  route_table_id = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.subnet-private[count.index].id
  route_table_id = var.enable_nat_gateway ? aws_route_table.private[0].id : null
}
output "subnet_and_cidr" {
  value = {
    public_subnets  = aws_subnet.subnet-public[*].id
    private_subnets = aws_subnet.subnet-private[*].id
    vpc_id          = aws_vpc.vpc-1.id
  }
  
}