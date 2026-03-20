#!/bin/bash

#secure-ssh.sh
#author kerryallen89
#creates a new ssh user using $1 parameters
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in

sudo useradd -m -d /home/${1} -s /bin/bash ${1}
sudo mkdir /home/${1}/.ssh
cd /home/kerry/SYS-265-01
sudo cp linux/public-keys/id_rsa.pub /home/${1}/.ssh/authorized_keys
sudo chmod 700 /home/${1}/.ssh
sudo chmod 600 /home/${1}/.ssh/authorized_keys
sudo chown -R ${1}:${1} /home/${1}/.ssh

# Blocks Root SSH Login
if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
   sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
else
   echo "PermitRootLogin not found in /etc/ssh/sshd_config"
fi

# Restarts the SSH Service
sudo service ssh restart
