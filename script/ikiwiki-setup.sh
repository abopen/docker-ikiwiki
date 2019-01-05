#! /bin/bash

SRC=/wiki/source
TMPL=/wiki/templates
DEST=/wiki/html

mkdir $SRC $DEST
cd /wiki

# Default .setup file
ikiwiki $SRC $DEST --url=http://$VIRTUAL_HOST --dumpsetup wiki.setup

# Update .setup file
ikiwiki --changesetup wiki.setup \
	--wikiname $WIKI_NAME \
	--cgi \
	--cgiurl http://$VIRTUAL_HOST/ikiwiki.cgi \
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
	--set theme=actiontabs

ikiwiki --setup wiki.setup

chmod -R 777 /wiki
