provider "aws" {
    region = "us-east-1"
}

#------------------------------------------------------------------------
# Key Pair
#------------------------------------------------------------------------
resource "aws_key_pair" "mykeypair" {
  key_name   = "MyTestKeyPair2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3/5sVAhbLFcrMLjKt2Opw+084HfBIpm58E1Nb+2kcrRwI93R8rb+jAOoDCcOlDw6SRwMFoDgA4CI6HO8Fb+V+28TS6UvZe3PgD6r0hwKcEXujy8PdLeRlDi098tkpJh/7l8r8GL0hnfb/pdWXg6qGAWfhwkB21yI2X/r/fjoQz2jMPiDe7B5OeljoNB5XZ6okAnz2iHop1bQQCk+TCsGoAIl1tFTwYDgjKo1oeCkz3OnYfzMfKvJv/QocVfxmYKFRIzEAqn/wQAT2bgmMce5eUKm1a9IxqPQp1KJCymR7jUUvoM1FJtLyVGlrgGaNgZOUOTOiuNTxk/4It0UTMCbB"
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
/*
resource "aws_security_group_rule" "allow_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.launch_config.id}"
}
*/

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

/*
#
# This Security Group is for the Elastic Load Balancer
#
resource "aws_security_group" "elb" {
    name = "terraform-example-elb"
    
    ingress {
	from_port = "${var.standard_port}"
	to_port = "${var.standard_port}"
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
    }
}

#
# Instances (Using a Launch Configuration since we don't yet have Launch Templates)
#
resource "aws_launch_configuration" "example" {
    image_id = "ami-40d28157"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.launch_config.id}"]

    user_data = "${file("user_data.sh")}"
    key_name = "MyTestKeyPair"

    lifecycle = {
	create_before_destroy = true
    }
}
*/
resource "aws_instance" "example" {
    instance_type = "t2.micro"
    ami = "ami-40d28157"
    security_groups = ["${aws_security_group.launch_config.id}"]

    user_data = "${file("user_data.sh")}"
    key_name = "MyTestKeyPair (user data all commands"
}

/*
#
# Auto Scaling Group
#
resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    health_check_type = "ELB"

    min_size = 1
    max_size = 2 

    tag {
	key = "Name"
	value = "terraform-asg-example"
	propagate_at_launch = true
    }
}
*/

/*
#
# Elastic Load Balancer
#
resource "aws_elb" "example" {
    name = "terraform-asg-example"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    security_groups = ["${aws_security_group.elb.id}"]

    listener {
	lb_port = "${var.standard_port}"
	lb_protocol = "http"
	instance_port = "${var.server_port}"
	instance_protocol = "http"
    }

    health_check {
	healthy_threshold = 2
	unhealthy_threshold = 2
	timeout = 3
	interval = 30
	target = "HTTP:${var.server_port}/"
    }
}

#------------------------------------------------------------------------
# Output
#------------------------------------------------------------------------
output "elb_dns_name" {
    value = "${aws_elb.example.dns_name}"
}
*/
