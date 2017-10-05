#!/usr/bin/env bash

installerlog="$HOME/install.log"
touch "$installerlog"



## Update system and install btrfs tools
sys_update() {
apt-get update
apt-get upgrade -y
apt-get install -y btrfs-tools
apt-get install python-pip -y
pip install softlayer  
} >> "$installerlog" 2>&1


## Create btrfs filesystem, mount it and update fstab
setup_btrfs() {
mkfs.btrfs /dev/xvdc /dev/xvde /dev/xvdf /dev/xvdg -f

mkdir /storage 
mount /dev/xvdc /storage

btuuid=$(lsblk --fs /dev/xvdc | grep -v UUID | awk '{print $3}')

echo "UUID=$btuuid /storage   btrfs  defaults 0 0" | sudo tee --append /etc/fstab
} >> "$installerlog" 2>&1

grab_ips() { 

hostip=$(curl -s https://api.service.softlayer.com/rest/v3/SoftLayer_Resource_Metadata/getPrimaryBackendIpAddress | cut -d '"' -f2)
s1id=$(/usr/local/bin/slcli --format raw vs list -H s1 | awk '{print $1}')
s2id=$(/usr/local/bin/slcli --format raw vs list -H s2 | awk '{print $1}')
s3id=$(/usr/local/bin/slcli --format raw vs list -H s3 | awk '{print $1}')
s4id=$(/usr/local/bin/slcli --format raw vs list -H s4 | awk '{print $1}')

s1privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s1id")
s2privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s2id")
s3privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s3id")
s4privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s4id")
}

## Install minio binary and create default files
setup_minio() { 
wget -O /usr/local/bin/minio https://dl.minio.io/server/minio/release/linux-amd64/minio

chmod +x /usr/local/bin/minio

cat <<EOT >> /etc/default/minio
# Local export path.
MINIO_VOLUMES=http://stor1/storage http://stor2/storage http://stor3/storage http://stor4/storage
MINIO_OPTS="-C /etc/minio --address $hostip:9000"

EOT

sed -i "s/stor1/$s1privIP/g" /etc/default/minio
sed -i "s/stor2/$s2privIP/g" /etc/default/minio
sed -i "s/stor3/$s3privIP/g" /etc/default/minio
sed -i "s/stor4/$s4privIP/g" /etc/default/minio

mkdir $HOME/temp
mount /dev/xvdh $HOME/temp
cat $HOME/temp/openstack/latest/user_data | awk '{print $1}' | cut -d '"' -f2 >> /etc/default/minio
cat $HOME/temp/openstack/latest/user_data | awk '{print $3}' | cut -d '"' -f2 >> /etc/default/minio

wget -O /etc/systemd/system/minio.service https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/distributed/minio.service

useradd -r minio-user -s /sbin/nologin
chown minio-user:minio-user /usr/local/bin/minio
chown minio-user:minio-user /storage

mkdir /etc/minio
chown minio-user:minio-user /etc/minio

systemctl enable minio.service
} >> "$installerlog" 2>&1

fix_hosts_issue() { 
sed -i "s/127.0.1.1/#127.0.1.1/g" /etc/hosts 
slcli='/usr/local/bin/slcli'

minioid=$(/usr/local/bin/slcli --format raw vs list -H minio | awk '{print $1}')
s1id=$(/usr/local/bin/slcli --format raw vs list -H s1 | awk '{print $1}')
s2id=$(/usr/local/bin/slcli --format raw vs list -H s2 | awk '{print $1}')
s3id=$(/usr/local/bin/slcli --format raw vs list -H s3 | awk '{print $1}')
s4id=$(/usr/local/bin/slcli --format raw vs list -H s4 | awk '{print $1}')

minioPubIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryIpAddress --id="$minioid")
s1privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s1id")
s2privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s2id")
s3privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s3id")
s4privIP=$(/usr/local/bin/slcli call-api Virtual_Guest getPrimaryBackendIpAddress --id="$s4id")

echo "$minioPubIP  minio.example.com	minio" | tee -a /etc/hosts
echo "$s1privIP  s1.example.com  s1" | tee -a /etc/hosts
echo "$s2privIP  s2.example.com  s2" | tee -a /etc/hosts
echo "$s3privIP  s3.example.com  s3" | tee -a /etc/hosts
echo "$s4privIP  s4.example.com  s4" | tee -a /etc/hosts
}

sys_update 
setup_btrfs
grab_ips
setup_minio
fix_hosts_issue

sleep 180 && shutdown -r now