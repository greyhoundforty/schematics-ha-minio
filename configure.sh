#!/usr/bin/env bash

# Author: Ryan Tiffany
# Email: rtiffany@us.ibm.com

# Script Variables
DIALOG='\033[0;36m' 
WARNING='\033[0;31m'
LINKY='\033[0;41m'
NC='\033[0m'

# Short description 
overview() { 
echo -e "${DIALOG}This script will help setting you your Schematics environment to properly deploy our distributed minio cluster.${NC}"
}

update_variables() { 
echo -n -e "${DIALOG}What is the name of your SSH key as it appears in the customer portal?${NC}  "

read -r sshkeyname

sed -i "s/YOURSSHKEYNAME/$sshkeyname/g" main.tf

}

overview
update_variables