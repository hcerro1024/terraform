#!/bin/bash
cat > /home/ec2-user/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDyqp5zHXrTI3U/Vgu8yZHL8Uwk9ds9eJBuT+Yx4FU99VX4dxnRTm2QIAHC40gTNWh+8ClkVq7CJ3qZTcbux6OepeQd5gKZhlrLItBCsXjTeCYF8I8GISPeX/QBq2wrCE8zAI+NyVh59VKgpRna1TLs3hrUhMhSg9RITKyU1ysl5Qtegt1Gu8Czc8hto+1ELG7zQZqGvovb4sjni2pJvIfLr0oLC3RyzIgUDKcsmw3bwQHxm7XU+cQfJMUlPry4vPk4fpGrPPhACSl/UK/NP2YMMasQYlwO1y+BPRSr7W3deYZzAEA2V5yd69cDrRSt5Vt2nRz52AMyd/AuOq1whVWv
EOF
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
yum install tigervnc-server -y
echo "Hello, World" > /var/www/html/index.html
