FROM debian:latest
MAINTAINER Ankit R Gadiya <me@argp.in>

# Packages _____________________________________________________________________
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
	&& rm -rf /var/lib/apt/lists/*
#_______________________________________________________________________________

# Configuration and Scripts ____________________________________________________
COPY config/nginx.conf /etc/nginx/sites-available/default
COPY templates/* /wiki/templates
COPY script/* /opt/
RUN ln -v /etc/nginx/sites-available/ikiwiki /etc/nginx/sites-enabled/ikiwiki \
	&& rm /etc/nginx/sites-enabled/default
#_______________________________________________________________________________

VOLUME ["/git", "/wiki"]

# Server _______________________________________________________________________
EXPOSE 80
CMD ["bash", "/opt/docker-entrypoint.sh"]
#_______________________________________________________________________________
