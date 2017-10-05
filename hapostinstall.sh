#!/usr/bin/env bash

# Install haproxy
install_ha() { 
add-apt-repository ppa:vbernat/haproxy-1.7 -y
apt-get update
apt-get upgrade -y
apt-get install -y haproxy
mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg-bak
systemctl enable haproxy
}

# Install slcli to pull correct IPs 
install_cli() { 
apt-get install python-pip -y
pip install softlayer
}

fix_hosts_issue() {
 
sed -i "s/127.0.1.1/#127.0.1.1/g" /etc/hosts 

minioid=$(/usr/local/bin/slcli --format raw vs list -H minio | awk '{print $1}')
s1id=$(/usr/local/bin/slcli --format raw vs list -H s1 | awk '{print $1}')
s2id=$(/usr/local/bin/slcli--format raw vs list -H s2 | awk '{print $1}')
s3id=$(/usr/local/bin/slcli --format raw vs list -H s3 | awk '{print $1}')
s4id=$(/usr/local/bin/slcli --format raw vs list -H s4 | awk '{print $1}')

minioPubIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryIpAddress --id="$minioid")
s1privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s1id")
s2privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s2id")
s3privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s3id")
s4privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s4id")

echo "$s1privIP  s1.example.com  s1" | tee -a /etc/hosts
echo "$s2privIP  s2.example.com  s2" | tee -a /etc/hosts
echo "$s3privIP  s3.example.com  s3" | tee -a /etc/hosts
echo "$s4privIP  s4.example.com  s4" | tee -a /etc/hosts
}

install_ha
install_cli
fix_hosts_issue