resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.0.0/24"
}

resource "aws_subnet" "main_1b" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "r" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoz3ejk4Of32grTGMfnBrVM5mC3eU6fHSOoth4sx4cTREYsRm/FdogrNxNJNDDy/7iDScK6wNermB4oThjqqC5BtmQN4qU37I0NIM8Xe8ttxw3VPy7PfOtw0b2pxpTDzeGvsjuEM3IPfQdFU6M9dOJKt4pCfMK/bfTwhcGCbuQc9M5sC4YGjYKK3s/ldQ2IF7m/KFr8VLeB1Qxx/T16Z9WNmXTKkXJsBmwMDvE5+DsLi12XcvUxi5EPvGGgpNRe7uATN4vgnCAOAwhdtwILwyKXZ8/TIV80ELevyfKXcsWI5C8OGGB1S3vhQUvnmF3x3IWy23lATjCVAdWWJG+CRNX"
}

resource "aws_instance" "lab" {
  ami                         = "ami-000a54989336780b5"
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.main_1a.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
}

resource "aws_ec2_instance_state" "test" {
  instance_id = aws_instance.lab.id
  state       = "running"
}