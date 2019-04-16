#!/bin/bash
cat > /home/ec2-user/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3/5sVAhbLFcrMLjKt2Opw+084HfBIpm58E1Nb+2kcrRwI93R8rb+jAOoDCcOlDw6SRwMFoDgA4CI6HO8Fb+V+28TS6UvZe3PgD6r0hwKcEXujy8PdLeRlDi098tkpJh/7l8r8GL0hnfb/pdWXg6qGAWfhwkB21yI2X/r/fjoQz2jMPiDe7B5OeljoNB5XZ6okAnz2iHop1bQQCk+TCsGoAIl1tFTwYDgjKo1oeCkz3OnYfzMfKvJv/QocVfxmYKFRIzEAqn/wQAT2bgmMce5eUKm1a9IxqPQp1KJCymR7jUUvoM1FJtLyVGlrgGaNgZOUOTOiuNTxk/4It0UTMCbB
EOF
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
yum install tigervnc-server -y
echo "Hello, World" > /var/www/html/index.html
