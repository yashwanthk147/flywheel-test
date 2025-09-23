
project = "flywhl"
env     = "dev"

vpc_cidr  = "172.19.0.0/16"


public_subnets = {
  pub1 = {
    cidr_block        = "172.19.1.0/24"
    availability_zone = "ap-south-1a"
    name              = "pub-1"
  }
  pub2 = {
    cidr_block        = "172.19.2.0/24"
    availability_zone = "ap-south-1b"
    name              = "pub-2"
  }
}

private_subnets = {
  priv1 = {
    cidr_block        = "172.19.101.0/24"
    availability_zone = "ap-south-1a"
    name              = "prvt-1"
  }
  priv2 = {
    cidr_block        = "172.19.102.0/24"
    availability_zone = "ap-south-1b"
    name              = "prvt-2"
  }
}