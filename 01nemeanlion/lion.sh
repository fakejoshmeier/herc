#! /bin/bash
read -p "Input a port number between (not including) 49151 and 65536.  In base 10, you fucking nerd.: " portnum
if ( ("$portnum" > 49151) && ("$portnum" < 65536) );
then
	echo "Port $portnum" >> etc/ssh/sshd_config
	service sshd restart
else
	echo "Incorrect port.  Don't include 49151 and 65536. Run again and try to get it right.\n"
	exit 1
fi
