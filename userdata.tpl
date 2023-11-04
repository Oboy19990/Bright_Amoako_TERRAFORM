!#/bin/bash
# user data to run inginx with ec2 instances
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "hello from $(hostname -f)" > /var/www/html/index.html 