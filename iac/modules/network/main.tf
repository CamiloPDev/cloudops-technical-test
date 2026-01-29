resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-vpc-${var.environment}"
      Environment = var.environment
    }
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "storage_private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.storage_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-storage-subnet-private-${count.index + 1}-${var.environment}"
      Environment = var.environment
      Type        = "storage"
      Tier        = "private"
    }
  )
}

resource "aws_subnet" "compute_private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.compute_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-compute-subnet-private-${count.index + 1}-${var.environment}"
      Environment = var.environment
      Type        = "compute"
      Tier        = "private"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-public-subnet-${count.index + 1}-${var.environment}"
      Environment = var.environment
      Tier        = "public"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-public-rt-${var.environment}"
      Environment = var.environment
      Tier        = "public"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-igw-${var.environment}"
      Environment = var.environment
    }
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-private-rt-${var.environment}"
      Environment = var.environment
      Tier        = "private"
    }
  )
}

resource "aws_route_table_association" "storage_private" {
  count          = 3
  subnet_id      = aws_subnet.storage_private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "compute_private" {
  count          = 3
  subnet_id      = aws_subnet.compute_private[count.index].id
  route_table_id = aws_route_table.private.id
}
