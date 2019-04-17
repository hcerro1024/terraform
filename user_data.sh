#!/bin/bash
cat > /home/ec2-user/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD10Ww05SRq+FHzylMC6ezpgVUZjHRJKtHdTQGQAX3yH+uWLwkQg9qciyiSn1Qbd2Pj1xSrp8U5K4T8L2GKUHTxhBJE55/wT6dL1fdTUEbzLDoLY6zOI6Xm2YCF/9nlfauovcic9dLEh4jHmlH5Tf3/Ztoapln8zkrEh2bvWSFi0CO1+83U2b4hp1au+5EQuDroymUeG90w8RMjTIqEUMU8mPRzWrClKe5D0D78b8d7OR6K3Hl7WTCzBQ0xg4DeCcy0apxnSxSVtJRhdlWF7LMSrUGzQr6cULasKBNr/KMvXw+hBZugqASqhLwSJuAaLKyOyKWv5ql59trCN9rTSLhd ec2-user@ip-172-31-93-42
EOF
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
yum install tigervnc-server -y
echo "Hello, World" > /var/www/html/index.html
