#!/bin/bash

# Update system
yum update -y

# Install necessary packages
yum install -y httpd

# Start and enable Apache service
systemctl start httpd
systemctl enable httpd

# Create directories for logs
mkdir /var/log/myapp

# Add test page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Welcome to my web app</title>
</head>
<body>
  <h1>Welcome to my web app</h1>
  <p>This is a test page.</p>
</body>
</html>
EOF

# Set permissions
chmod -R 755 /var/www/html

# Configure web server
echo "This is the configuration for my web server." > /var/www/html/config.txt
