#!/bin/bash

sudo apt-get update
sudo apt-get install -y git make mercurial

cd
echo 'export PATH=$PATH:$HOME/terraform:$HOME/go/bin' >> ~/.bashrc
export PATH=$PATH:$HOME/terraform:$HOME/go/bin

sudo wget -O /usr/local/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
sudo chmod +x /usr/local/bin/gimme
/usr/local/bin/gimme 1.6 >> ~/.bashrc
eval "$(/usr/local/bin/gimme 1.6)"

mkdir ~/go
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export GO15VENDOREXPERIMENT=1' >> ~/.bashrc
export GOPATH=$HOME/go
source ~/.bashrc

go get github.com/tools/godep
go get github.com/hashicorp/terraform
cd $GOPATH/src/github.com/hashicorp/terraform
godep restore

cd
go get github.com/jtopjian/cobblerclient

# Cobbler
sudo apt-get install -y cobbler cobbler-web debmirror dnsmasq
sudo cp /home/ubuntu/files/cobbler/modules.conf /etc/cobbler
sudo cp /home/ubuntu/files/cobbler/dnsmasq.template /etc/cobbler
sudo cp /home/ubuntu/files/cobbler/settings /etc/cobbler
sudo cp /home/ubuntu/files/cobbler/users.digest /etc/cobbler

# The stock version of Cobbler in the Ubuntu repository still has the old cobbler homepage URL
# This file replaces it with the correct URL.
sudo cp /home/ubuntu/files/cobbler/action_dlcontent.py /usr/lib/python2.7/dist-packages/cobbler
sudo rm /usr/lib/python2.7/dist-packages/cobbler/action_dlcontent.pyc

sudo /etc/init.d/apache2 restart
sudo stop cobbler
sleep 2
sudo start cobbler
sleep 10
sudo cobbler get-loaders
sudo cobbler sync

# Import an Ubuntu 1404 distro
cd /tmp
wget http://old-releases.ubuntu.com/releases/14.04.2/ubuntu-14.04-server-amd64.iso
sudo mount -o loop ubuntu-14.04-server-amd64.iso /mnt
sudo cobbler import --name Ubuntu-14.04 --breed ubuntu --path /mnt
