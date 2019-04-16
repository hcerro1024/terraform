provider "aws" {
    region = "us-east-1"
}

#------------------------------------------------------------------------
# Data
#------------------------------------------------------------------------
# Used in Autoscaling Group and ELB
data "aws_availability_zones" "all" {}

#------------------------------------------------------------------------
# Resources
#------------------------------------------------------------------------
#
# Security Group Rules
#

resource "aws_security_group_rule" "allow_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.launch_config.id}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks = ["0.0.0.0/0"]          

  security_group_id = "${aws_security_group.launch_config.id}"
}

#
# Security Groups
#
resource "aws_security_group" "launch_config" {
    name = "terraform-example-instance"

    ingress {
	from_port   = "${var.server_port}"
	to_port     = "${var.server_port}"
	protocol    = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle = {
	create_before_destroy = true
    }
}

resource "aws_instance" "example" {
    instance_type = "t2.micro"
    ami = "ami-40d28157"
    security_groups = ["${aws_security_group.launch_config.name}"]

    user_data = "${file("user_data.sh")}"
    key_name = "MyTestKeyPair"
    tags = {
        Name = "My Test Server"
    }
}
