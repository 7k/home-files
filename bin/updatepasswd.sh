#!/bin/bash
#
echo "Old password:"
read -es passwdOld
echo "New password"
read -es passwdNew
sed -i "s/$passwdOld/$passwdNew/g" ~/.subversion/servers
if [ -e /etc/yum.conf ]; then
	sudo sed -i "s/$passwdOld/$passwdNew/g" /etc/yum.conf
fi

if [ -e ~/.credentials ]; then
	sudo sed -i "s/$passwdOld/$passwdNew/g" ~/.credentials
fi
if [ -e /root/.credentials ]; then
	sudo sed -i "s/$passwdOld/$passwdNew/g" /root/.credentials
fi

cp .subversion/servers "`cygpath "$USERPROFILE"`/Application Data/Subversion/"
