#!/bin/bash

REPO=/wiki/wiki.git
SRC=/wiki/source
TMPL=/wiki/templates
DEST=/wiki/html

cd /wiki

tmpfile=$(mktemp)
cat > $tmpfile <<EOF
#!/bin/bash

# Start with default config
ikiwiki $SRC $DEST --url=https://$VIRTUAL_HOST --dumpsetup wiki.setup

# Set base config
ikiwiki --changesetup wiki.setup \
	--wikiname '$WIKI_NAME' \
	--cgi \
	--cgiurl https://$VIRTUAL_HOST/ikiwiki.cgi \
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
	--plugin color \
	--rcs=git \
	--set cgi_wrapper=$DEST/ikiwiki.cgi \
	--set git_wrapper=$REPO/hooks/post-update \
        --set reverse_proxy=1 \
	--set theme=actiontabs

# Set optional config
[[ -n "$ADMIN_EMAIL" ]] && ikiwiki --changesetup wiki.setup \
	--adminemail $ADMIN_EMAIL

[[ -n "$ADMIN_USER" ]] && ikiwiki --changesetup wiki.setup \
        --adminuser $ADMIN_USER

[[ -n "$LOCKED_PAGES" ]] && ikiwiki --changesetup wiki.setup \
	--set locked_pages='$LOCKED_PAGES'

[[ -n "$LOGO" ]] && ikiwiki --changesetup wiki.setup \
	--templatedir $TMPL

[[ -n "$RSS" ]] && ikiwiki --changesetup wiki.setup \
	--rss 1

[[ -n "$ATOM" ]] && ikiwiki --changesetup wiki.setup \
        --atom 1

[[ -n "$SEARCH" ]] && ikiwiki --changesetup wiki.setup \
        --plugin search

[[ -n "$NO_DISCUSSION" ]] && ikiwiki --changesetup wiki.setup \
        --discussion 0

[[ -n "$NO_EDIT" ]] && ikiwiki --changesetup wiki.setup \
	--disable-plugin editpage

[[ -n "$NO_RECENTCHANGES" ]] && ikiwiki --changesetup wiki.setup \
        --disable-plugin recentchanges

# Rebuild the wiki and wrappers
ikiwiki --setup wiki.setup --rebuild --wrappers
EOF

chmod 755 $tmpfile
su www-data -c $tmpfile
