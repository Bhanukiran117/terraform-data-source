
provider "aws" {
	region = "eu-west-1"
	profile = "Bhanu-Terraform"
	shared_credentials_file = "/home/bhanu/.aws/credentials"
}
data "aws_caller_identity" "current" {}

data "aws_vpc" "get_vpc" {
    filter {
        name = "tag:Name"
        values = ["my-test-vpc"]
    }
}

data "aws_security_group" "get_security_group_id" {
    filter {
        name = "tag:Name"
        values = ["my-test-security-group"]
    }
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.get_vpc.id]
    }

}

variable "amiid" {
	type = string
	default = "ami-00890f614e48ce866"
}

resource "aws_instance" "bhanu_test_ec2" {
	ami = var.amiid
	instance_type = "t2.micro"
	key_name = "KeyPair-April30"
	vpc_security_group_ids = [data.aws_security_group.get_security_group_id.id]
	tags = {
		Name = "db tag"
	}	

}

output "aws_security_group_id" {
    value = data.aws_security_group.get_security_group_id.id
}

output "aws_vpc_id" {
    value = data.aws_vpc.get_vpc.id
}