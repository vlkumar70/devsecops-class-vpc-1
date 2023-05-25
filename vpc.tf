
# 1. VPC
resource "aws_vpc" "devops-vpc" {
  cidr_block           = "10.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devsecops-vpc-terraform"
  }
}

## 2. Create Subnets

# # ## Availability Zone (1a) - public-subnet-1a, application-private-1a, database-private-1a
resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.16.16.0/20"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet-terraform-1a"
  }
}

resource "aws_subnet" "application-private-1a" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.16.32.0/20"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "application-private-terraform-1a"
  }
}

resource "aws_subnet" "database-private-1a" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.16.48.0/20"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "database-private-terraform-1a"
  }
}

# # ## Availability Zone (1b) - public-subnet-1b. application-private-1b, database-private-1b
resource "aws_subnet" "public-subnet-1b" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.16.64.0/20"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "public-subnet-terraform-1b"
  }
}

resource "aws_subnet" "application-private-1b" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.16.80.0/20"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "application-private-terraform-1b"
  }
}

resource "aws_subnet" "database-private-1b" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.16.96.0/20"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "database-private-terraform-1b"
  }
}

# # ## Availability Zone (1c) - public-subnet-1c. application-private-1c, database-private-1c
resource "aws_subnet" "public-subnet-1c" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.16.112.0/20"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "public-subnet-terraform-1c"
  }
}

resource "aws_subnet" "application-private-1c" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.16.128.0/20"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "application-private-terraform-1c"
  }
}

resource "aws_subnet" "database-private-1c" {
  vpc_id                  = aws_vpc.devops-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.16.144.0/20"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "database-private-terraform-1c"
  }
}


# # ## Route table
resource "aws_route_table" "devops-public-rt" {
  vpc_id = aws_vpc.devops-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-igw.id
  }

  tags = {
    Name = "public-route-table-terraform"
  }
}

resource "aws_route_table" "devops-application-rt" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = {
    Name = "application-route-table-terraform"
  }
}

resource "aws_route_table" "devops-database-rt" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = {
    Name = "database-route-table-terraform"
  }
}

resource "aws_route_table_association" "public-association-1" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.devops-public-rt.id
}

resource "aws_route_table_association" "public-association-2" {
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.devops-public-rt.id
}

resource "aws_route_table_association" "public-association-3" {
  subnet_id      = aws_subnet.public-subnet-1c.id
  route_table_id = aws_route_table.devops-public-rt.id
}

resource "aws_route_table_association" "application-association-1" {
  subnet_id      = aws_subnet.application-private-1a.id
  route_table_id = aws_route_table.devops-application-rt.id
}

resource "aws_route_table_association" "application-association-2" {
  subnet_id      = aws_subnet.application-private-1b.id
  route_table_id = aws_route_table.devops-application-rt.id
}

resource "aws_route_table_association" "application-association-3" {
  subnet_id      = aws_subnet.application-private-1c.id
  route_table_id = aws_route_table.devops-application-rt.id
}

resource "aws_route_table_association" "database-association-1" {
  subnet_id      = aws_subnet.database-private-1a.id
  route_table_id = aws_route_table.devops-database-rt.id
}

resource "aws_route_table_association" "database-association-2" {
  subnet_id      = aws_subnet.database-private-1b.id
  route_table_id = aws_route_table.devops-database-rt.id
}

resource "aws_route_table_association" "database-association-3" {
  subnet_id      = aws_subnet.database-private-1c.id
  route_table_id = aws_route_table.devops-database-rt.id
}


# ## IGW
resource "aws_internet_gateway" "devops-igw" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = {
    Name = "devops-igw-terraform"
  }
}

### EC2 Resources
## Security group
data "external" "whatismyip" {
  program = ["/bin/bash", "${path.module}/files/whatismyip.sh"]
}

resource "aws_security_group" "allow_ssh" {
  name        = "devsecops-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.devops-vpc.id

  ingress {
    description = "SSH from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
  }

  ingress {
    description = "SSH from my ip"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-public-sg"
  }
}
## IAM Role
# IAM Role
resource "aws_iam_role" "iam_for_ec2" {
  name = "devsecops-s3-sqs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "devsecops-s3-sqs-profile"
  role = aws_iam_role.iam_for_ec2.name
}

# IAM policy document
data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "SqsAndS3Access"
    effect    = "Allow"
    actions   = ["sqs:*", "s3:*"]
    resources = ["*"]
  }

  statement {
    sid       = "IamDescribe"
    effect    = "Allow"
    actions   = ["iam:Describe*"]
    resources = ["*"]
  }

}

# IAM policy
resource "aws_iam_policy" "iam_role_policy" {
  name        = "devsecops-sqs-s3-policy"
  description = "devsecops-sqs-s3-policy"
  policy      = data.aws_iam_policy_document.policy.json
}

# IAM policy attachment to role
resource "aws_iam_policy_attachment" "iam_role_policy-attach" {
  name       = "lambda_iam_role_policy_attach"
  roles      = [aws_iam_role.iam_for_ec2.name]
  policy_arn = aws_iam_policy.iam_role_policy.arn
}

## Create EC2

## pre-req (keypair, amiid, )

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "devsecops-public-ec2" {
  ami                         = data.aws_ami.amazon-linux-2.id
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.iam_profile.name
  associate_public_ip_address = true
  key_name                    = "new_key"
  subnet_id                   = aws_subnet.public-subnet-1a.id
  security_groups             = [aws_security_group.allow_ssh.id]
  user_data                   = file("files/apache_config.sh")
  tenancy                     = "default"

  tags = {
    Name = "public-ec2-terraform"
  }
}
