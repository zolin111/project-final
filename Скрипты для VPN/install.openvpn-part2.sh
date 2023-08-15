;#!/bin/bash 
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

	ret=$(ps aux | grep openvpn_exporter | wc -l)
	if [ "$ret" -eq 0 ]
then {
	echo "Running OpenVpn Exporter" #output text
        sleep 1  #delay
	sudo systemctl start openvpn_exporter #command for run program
	exit 1
}
else 
{
	echo "Openvpn already running!"
	exit 1
}
fi;
 
