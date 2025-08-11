#!/bin/bash
# Update the package index
dnf update -y

# Install Apache HTTP Server
dnf install -y httpd

# Enable and start Apache service
systemctl enable httpd
systemctl start httpd

# Optional: Add a sample index page
echo "<h1>Hello from Amazon Linux 2023 Apache Server!</h1>" > /var/www/html/index.html
