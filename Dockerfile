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
	&& rm -rf /var/lib/apt/lists/*

COPY config/nginx.conf /etc/nginx/sites-available/default
COPY templates/* /wiki/templates/
COPY script/* /opt/bin/

VOLUME ["/import", "/wiki"]

EXPOSE 80

CMD ["bash", "/opt/bin/docker-entrypoint.sh"]
