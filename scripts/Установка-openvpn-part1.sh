#!/bin/bash
sudo apt update
sudo apt install openvpn easy-rsa
mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
sudo chown yc-user ~/easy-rsa
chmod 700 ~/easy-rsa
echo "set_var EASYRSA_ALGO "ec"
set_var EASYRSA_DIGEST "sha512" " > sudo vim ~/easy-rsa/vars
cd ~/easy-rsa
./easyrsa init-pki
cd ~/easy-rsa
./easyrsa gen-req server nopass
cp pki/private/server.key /etc/openvpn/server/
mkdir -p ~/clients/keys
chmod -R 700 ~/clients
sudo chown yc-user.yc-user ~/clients/keys/*


