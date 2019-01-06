#!/bin/bash

REPO=/wiki/wiki.git
SRC=/wiki/source
TMPL=/wiki/templates
DEST=/wiki/html

cd /wiki

# Default .setup file
ikiwiki $SRC $DEST --url=https://$VIRTUAL_HOST --dumpsetup wiki.setup

# Update .setup file
ikiwiki --changesetup wiki.setup \
	--wikiname $WIKI_NAME \
	--cgi \
	--cgiurl https://$VIRTUAL_HOST/ikiwiki.cgi \
	--adminuser www-data \
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
	--set git_wrapper=$REPO/hooks/post-update \
        --set reverse_proxy=1 \
	--set theme=actiontabs

ikiwiki --setup wiki.setup --rebuild --wrappers

chmod -R 777 /wiki
