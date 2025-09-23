data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-s3-st"
    key    = "dev-state/vpc.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "app" {
  backend = "s3"
  config = {
    bucket = "terraform-s3-st"
    key    = "dev-state/asg.tfstate"
    region = "ap-south-1"
  }
}
