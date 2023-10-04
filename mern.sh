#!/bin/bash
#Author: Visahl Samson David Selvam
#Date: 04 October 2023

# Update the package list
sudo apt update

# Install curl if it's not already installed
sudo apt install -y curl

# Install the latest version of Node.js and npm using NodeSource
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install the latest version of npm
sudo npm install -g npm

# Install Yarn
sudo npm install -g yarn

# Verify the installation
node -v
npm -v
yarn --version
