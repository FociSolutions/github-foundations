#!/bin/sh

# This script automates the setup of a development environment for the
# project.
green="\033[0;32m"
red="\033[0;31m"
yellow="\033[0;33m"
no_color="\033[0m"

# Check if the user is in the project directory
if [ ! -d ".git" ]; then
  echo "${red}Error: You are not in the project directory.${no_color}"
  exit
fi


# Copy the hooks into the .git/hooks directory
echo "Copying hooks to .git/hooks directory..."
cp -r hooks/* .git/hooks/
echo "${green}Done.${no_color}"

# Copy the .gitmessage to the user's home directory
echo "Copying .gitmessage to user's home directory..."
cp .gitmessage ~/.gitmessage
echo "${green}Done.${no_color}"

# Install the pre-commit hook to the .git/hooks directory
echo "Installing pre-commit hook..."
pre-commit install
pre-commit install --hook-type commit-msg --hook-type pre-push
echo "${green}Done.${no_color}"
