#! /bin/bash

DIR=/wiki

check_ikiwiki()
{
	cd $DIR
	if [[ -d "html" && -f "wiki.setup" ]]
	then
		echo "Ikiwiki setup present"
		return 0
	else
		echo "Setting up Ikiwiki"
		bash /opt/ikiwiki-setup.sh
		return
	fi
}

start_nginx()
{
	# Update Virtual Host with Environment Variable
        echo "Setting Nginx server_name to $VIRTUAL_HOST"
	sed -i -e \
		"s/VIRTUAL_HOST/$VIRTUAL_HOST/g" /etc/nginx/sites-available/default

        echo "Starting Nginx"
	service fcgiwrap restart
	nginx -g 'daemon off;'
}

main()
{
	check_ikiwiki
	start_nginx

	exit 0
}

main
