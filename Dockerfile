FROM debian:latest
LABEL maintainer="andrew@abopen.com"

RUN apt-get update \
	&& apt-get install -y \
		nginx \
		fcgiwrap \
		perlmagick \
		python \
		ikiwiki \
		libxml-writer-perl \
		xapian-omega \
		libsearch-xapian-perl \
		libdigest-sha-perl \
		libhtml-scrubber-perl \
		libxml-writer-perl \
		openssh-server \
		supervisor \
	&& rm -rf /var/lib/apt/lists/*

# Activate the www-data account 
RUN echo www-data:www-data | chpasswd \
	&& chsh -s /bin/bash www-data

# Setup SSH

RUN mkdir /var/run/sshd \
	&& chmod 700 /var/run/sshd \
	&& sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Setup the Ikiwiki directory
RUN mkdir /wiki \
	&& chown www-data: /wiki

# Copy configurations
COPY config/nginx.conf /etc/nginx/sites-available/default
COPY config/ikiwiki_supervisord.conf /etc/supervisor/conf.d/
COPY templates/* /wiki/templates/
COPY script/* /opt/bin/

VOLUME ["/import", "/wiki"]

EXPOSE 22 80

CMD ["bash", "/opt/bin/docker-entrypoint.sh"]
