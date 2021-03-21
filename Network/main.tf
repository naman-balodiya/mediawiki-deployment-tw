resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.envname}-VPC"
    Environment = var.envname
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [aws_vpc.VPC]
  tags = {
    Name = "${var.envname}-IGW"
    Environment = var.envname
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = var.public_cidr
  vpc_id = aws_vpc.VPC.id
  depends_on = [aws_vpc.VPC]
  availability_zone = var.AZ[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.envname}-Public-Subnet"
    Environment = var.envname
  }
}


resource "aws_subnet" "private_subnet" {
  cidr_block = var.private_cidr
  vpc_id = aws_vpc.VPC.id
  availability_zone = var.AZ[0]
  tags = {
    Name = "${var.envname}-Private-Subnet"
    Environment = var.envname
  }
}



resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [aws_vpc.VPC]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.envname}-PublicRT"
    Environment = var.envname
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [aws_vpc.VPC]

  tags = {
    Name = "${var.envname}-PrivateRT"
    Environment = var.envname
  }
}

resource "aws_route_table_association" "public_rt" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "private_rt" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_subnet.id
}

output "vpc_id" {
  value = aws_vpc.VPC.id
  depends_on = [aws_vpc.VPC]
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
  depends_on = [aws_subnet.public_subnet]
}

output "private_subnet" {
  value = aws_subnet.private_subnet.id
  depends_on = [aws_subnet.private_subnet]
}
