#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
yum install tigervnc-server -y
echo "Hello, World" > /var/www/html/index.html