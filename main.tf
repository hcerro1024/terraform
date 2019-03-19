provider "aws" {
    region = "us-east-1"
}

# Used in Autoscaling Group and ELB
data "aws_availability_zones" "available" {}

data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

data "aws_subnet" "example" {
  count = "${length(data.aws_subnet_ids.example.ids)}"
  id    = "${data.aws_subnet_ids.example.ids[count.index]}"
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
	from_port   = "${var.server_port}"
	to_port     = "${var.server_port}"
	protocol    = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle = {
	create_before_destroy = true
    }
}

resource "aws_security_group" "subnet" {
  vpc_id = "${data.aws_subnet.selected.vpc_id}"

  ingress {
    cidr_blocks = ["${data.aws_subnet.selected.cidr_block}"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}

resource "aws_security_group" "elb" {
    name = "terraform-example-elb"
    
    ingress {
	from_port = 80
	to_port = 80
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

# Using a Launch Configuration since we don't yet have Launch Templates
resource "aws_launch_configuration" "example" {
    image_id = "ami-40d28157"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
		#!/bin/bash
		echo "Hello, World" > index.html
		nohup busybox httpd -f -p "${var.server_port}" &
		EOF

    lifecycle = {
	create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones = ["${data.aws_availability_zones.available.names}"]

    load_balancers = ["${aws_lb.example.name}"]
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
	key = "Name"
	value = "terraform-asg-example"
	propagate_at_launch = true
    }
}

resource "aws_lb" "example" {
    name = "terraform-asg-example"
	internal = false
	load_balancer_type = "network"
	bucket = "linkin-acloud-guru"
	enabled = true
	subnets            = "${element(data.aws_subnet_ids.example.ids, count.index)}"
    availability_zones = ["${data.aws_availability_zones.available.names}"]
    security_groups = ["${aws_security_group.subnet.id}"]

    listener {
	lb_port = 80
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
	
	tags = {
		Environment = "training"
	}	
}

output "elb_dns_name" {
    value = "${aws_lb.example.dns_name}"
}
