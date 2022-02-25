  # TASK 2

  # declaration of variable

  myname='prateek'
  s3_bucket='upgrad-prateek'
  timestamp=$(date '+%d%m%Y-%H%M%S')


  # pakage update


  apt update -y


 # check apache2 server

 if [ $(dpkg --list | grep apache2 | cut -d ' ' -f 3 | head -1) == 'apache2' ]
then
	echo "Apache2 is installed...checking for its state"
	if [ $(systemctl status apache2 | grep disabled | cut -d ';' -f 2) == ' disabled' ]
		then
			systemctl enable apache2
			echo "Apache2 server are installed"
			systemctl start apache2
# now check server is running or not
		else
			if [ $(systemctl status apache2 | grep active | cut -d ':' -f 2 | cut -d ' ' -f 2) == 'active' ]
			then
				echo "Apache2 is already running"
			else
				systemctl start apache2
				echo "Apache2 server start"
			fi
	fi
 else
	echo "Apache2 not installed...installation is under process"
	print 'Y\n' | apt-get install apache2
	echo "Apache2 server is running"
	
fi
#  creating tar archive
tar -zvcf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
# upload tar files
if [ $(dpkg --list | grep awscli | cut -d ' ' -f 3 | head -1) == 'awscli' ]

	then
		aws s3 \
		cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
		s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
	else
	echo "awscli is not found, installing now..."
	apt install awscli
	aws s3 \
	cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
	s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

fi
