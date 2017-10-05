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
echo -e "${DIALOG}This script will help setting you your Schematics environment to properly deploy our distributed minio cluster.${NC} "
}

# Check if terraform is installed (#TODO) 
#system_check() { 
#command -v terraform >/dev/null 2>&1
#}

# If you do not have a domain hosted with SoftLayer the configuration script will use an alternate main.tf file
choose_version() { 

echo -n -e "${DIALOG}Do you have a domain hosted with SoftLayer? [y/n]${NC}  "
read -r sldomain

case $sldomain in 
	[nN])
	mv main.tf main.tf-bak
	mv nodns.main.tf main.tf 
	;;
	*)
	echo -n -e "${DIALOG}What is the domain name you are hosting at SoftLayer?${NC}  "
	read -r domainname
	sed -i "s/example.com/$domainname/g" main.tf
	;;
esac
}

update_variables() { 

echo -n -e "${DIALOG}What is your SoftLayer username?${NC}  "
read -r sluser
export TF_VAR_slusername="$sluser"

echo -n -e "${DIALOG}What is your SoftLayer API Key?${NC}  "
read -r slapi
export TF_VAR_slapikey="$slapi"

echo -n -e "${DIALOG}What is the name of your SSH key as it appears in the customer portal?${NC}  "
read -r sshkeyname
sed -i "s/YOURSSHKEYNAME/$sshkeyname/g" main.tf

echo -n -e "${DIALOG}What would you like to set your minio access key to?${NC}  "
read -r minioaccesskey 
export TF_VAR_accesskey="$minioaccesskey"

echo -n -e "${DIALOG}What would you like to set your minio secret key to?${NC}  "
read -r miniosecretkey 
export TF_VAR_secretkey="$miniosecretkey"

if [[ ! -f $HOME/.softlayer ]]; then 
	cp softlayer $HOME/.softlayer 
	sed -i "s/YOUR_SOFTLAYER_API_KEY/$slapi/g" $HOME/.softlayer
	sed -i "s/YOUR_SOFTLAYER_USERNAME/$sluser/g" $HOME/.softlayer
else 
	echo "System already configured to use slcli"

}

overview
choose_version
update_variables