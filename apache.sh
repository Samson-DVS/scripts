#!/bin/bash
# Author: Visahl Samson David Selvam
# Date: 04 October 2023

# Update package lists
sudo apt-get update

# Install essential build tools and libraries
sudo apt-get install -y build-essential

# Download Apache source code (corrected URL for Apache 2.4.57)
wget https://downloads.apache.org/httpd/httpd-2.4.57.tar.gz

# Extract the downloaded archive
tar -xzvf httpd-2.4.57.tar.gz

# Navigate to the extracted directory
cd httpd-2.4.57

# Configure Apache with desired options (you can add more options as needed)
./configure

# Build Apache
make

# Install Apache to the system
sudo make install

# Update Apache to the latest version
sudo apt-get install --only-upgrade apache2

# Harden Apache web server
sudo a2enmod headers
sudo a2enmod ssl
sudo a2enmod rewrite

# Configure Apache security settings
sudo tee -a /etc/apache2/conf-available/security-headers.conf > /dev/null << EOF
Header always set X-Frame-Options SAMEORIGIN
Header always set X-XSS-Protection "1; mode=block"
Header always set Content-Security-Policy "default-src 'self'"
Header always set Strict-Transportation-Security "max-age=31536000; includeSubDomains; preload"
EOF
sudo a2enconf security-headers

# Hide Apache version information
echo "ServerTokens Prod" | sudo tee -a /etc/apache2/conf-available/security.conf > /dev/null
echo "ServerSignature Off" | sudo tee -a /etc/apache2/conf-available/security.conf > /dev/null
echo "FileETag None" | sudo tee -a /etc/apache2/conf-available/security.conf > /dev/null

# Disable .htaccess override
sudo tee -a /etc/apache2/apache2.conf > /dev/null << EOF
<Directory /usr/local/apache2/htdocs/>
    AllowOverride None
</Directory>
EOF

# Disable SSI and CGI (you can adjust these as needed)
sudo a2dismod include
sudo a2dismod cgi

# Restart Apache service
sudo systemctl restart apache2

# Output a message indicating the installation and update are complete
echo "Apache 2.4.57 has been successfully installed and updated to the latest version."
