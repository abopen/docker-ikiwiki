#! /bin/bash

SRC=/git
TMPL=/wiki/templates
DEST=/wiki/html

mkdir $DEST
cd /wiki

# Default .setup file
ikiwiki $SRC $DEST --url=http://127.0.0.1 --dumpsetup wiki.setup

# Update .setup file
ikiwiki --changesetup wiki.setup \
	--wikiname $WIKI_NAME \
	--cgi \
	--cgiurl http://127.0.0.1/ikiwiki.cgi \
	--adminuser admin \
	--plugin websetup \
	--plugin 404 \
	--plugin goodstuff \
	--plugin favicon \
	--plugin theme \
	--plugin typography \
	--plugin img \
	--plugin sidebar \
	--plugin sparkline \
	--plugin postsparkline \
	--plugin remove \
	--rcs=git \
	--templatedir $TMPL \
	--set cgi_wrapper=$DEST/ikiwiki.cgi \
        --set reverse_proxy=1 \
	--set theme=actiontabs

ikiwiki --setup wiki.setup

chmod -R 777 /wiki
