#!/bin/bash 

mkdir -p ~/clients/files
chmod -R 700 ~/clients

cd ~/easy-rsa
openvpn --genkey --secret ta.key
sudo cp ta.key /etc/openvpn/server/

cd ~/easy-rsa
./easyrsa gen-req client-1 nopass

cp pki/private/client-1.key ~/clients/keys/
cp ~/easy-rsa/ta.key ~/clients/keys/
sudo cp /etc/openvpn/server/ca.crt ~/clients/keys/

sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/server/
sudo gunzip /etc/openvpn/server/server.conf.gz

cd ~/clients
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/clients/base.conf
 
