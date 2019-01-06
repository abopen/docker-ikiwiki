#!/bin/bash

DIR=/wiki

check_git()
{
	cd $DIR
	if [[ -d "wiki.git" && -d "source" ]]
	then
		echo "Git setup present"
		return 0
	else
		echo "Setting up Git"
		bash /opt/bin/git-setup.sh
		return
	fi
}

check_ikiwiki()
{
	cd $DIR
	if [[ -d "html" && -f "wiki.setup" ]]
	then
		echo "Ikiwiki setup present"
		return 0
	else
		echo "Setting up Ikiwiki"
		bash /opt/bin/ikiwiki-setup.sh
		return
	fi
}

start_nginx()
{
        echo "Setting Nginx server_name to $VIRTUAL_HOST"
	sed -i -e \
		"s/VIRTUAL_HOST/$VIRTUAL_HOST/g" /etc/nginx/sites-available/default

        echo "Starting Nginx"
	service fcgiwrap restart
	nginx -g 'daemon off;'
}

main()
{
	check_git
	check_ikiwiki
	start_nginx

	exit 0
}

main
