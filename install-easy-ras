#!/bin/bash


sudo apt install easy-rsa

mkdir ~/easy-rsa

ln -s /usr/share/easy-rsa/* ~/easy-rsa/

chmod 700 /home/yc-user/easy-rsa

cd ~/easy-rsa
./easyrsa init-pki


echo 'set_var EASYRSA_REQ_COUNTRY    "RU"
set_var EASYRSA_REQ_PROVINCE   "Moscow"
set_var EASYRSA_REQ_CITY       "Moscow"
set_var EASYRSA_REQ_ORG        "XXX"
set_var EASYRSA_REQ_EMAIL      "admin@example.com"
set_var EASYRSA_REQ_OU         "Community"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"' > ~/easy-rsa/vars


./easyrsa build-ca
