#!/bin/bash
#Author: Visahl Samson David Selvam
#Date: 04 October 2023

# Update package lists
sudo apt-get update

# Install Apache web server
sudo apt-get install -y apache2

# Harden Apache web server
sudo a2enmod headers
sudo a2enmod ssl
sudo a2enmod rewrite

# Configure Apache security settings
sudo tee -a /etc/apache2/conf-available/security-headers.conf > /dev/null << EOF
Header always set X-Frame-Options SAMEORIGIN
Header always set X-XSS-Protection "1; mode=block"
Header always set Content-Security-Policy "default-src 'self'"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
EOF
sudo a2enconf security-headers

# Hide Apache version information
echo "ServerTokens Prod" | sudo tee -a /etc/apache2/conf-available/security.conf > /dev/null
echo "ServerSignature Off" | sudo tee -a /etc/apache2/conf-available/security.conf > /dev/null
echo "FileETag None" | sudo tee -a /etc/apache2/conf-available/security.conf > /dev/null

# Disable .htaccess override
sudo tee -a /etc/apache2/apache2.conf > /dev/null << EOF
<Directory /var/www/>
    AllowOverride None
</Directory>
EOF

# Disable SSI and CGI
sudo a2dismod include
sudo a2dismod cgi

# Restart Apache service
sudo systemctl restart apache2
