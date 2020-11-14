#!/bin/bash

#https://github.com/tendai-lino/easyrsa-automation/blob/main/easy-script.sh
# Copyright (c) 2020 Tendai-lino. Released under the MIT License
case $1 in
install)
sudo apt  install awscli -y
if [ ! -d "/home/$USER/easy-rsa/" ];
then
echo installing EasyRSA
echo cloning from github
mkdir vpncerts
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3
./easyrsa init-pki

./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
else echo easyrsa already installed ,to create new vpnuser run: ./easy-script adduser
fi
;;
adduser)
echo enter username
read varname
echo creating vpnuser client cert for $varname

cd easy-rsa/easyrsa3
./easyrsa build-client-full $varname nopass

cp /home/$USER/easy-rsa/easyrsa3/pki/issued/* /home/$USER/vpncerts
cp /home/$USER/easy-rsa/easyrsa3/pki/private/* /home/$USER/vpncerts
cp /home/$USER/easy-rsa/easyrsa3/pki/*.crt /home/$USER/vpncerts
;;
import-acm)
echo enter region name  e,g af-south-1
read varname
# to ACM region $varname
aws acm import-certificate --certificate fileb://vpncerts/server.crt --private-key fileb://vpncerts/server.key --certificate-chain fileb://vpncerts/ca.crt --region $varname

;;
*)
echo usage : ./easy-script options: install ,adduser ,import-acm
;;
esac
