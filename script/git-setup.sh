#!/bin/bash

IMPORT=/import
REPO=/wiki/wiki.git
SRC=/wiki/source

die() {
    echo $0
    exit 1
}

cd $IMPORT
git status 2>&1 > /dev/null
if [[ $? -ne 0 ]] ; then
    die "Cannot find a git repository at $IMPORT"
fi
cd -

set -e
git clone --bare $IMPORT $REPO
chown -R www-data: $REPO
tmpfile=$(mktemp)
cat > $tmpfile <<EOF
#!/bin/bash
git clone $REPO $SRC
EOF
chmod 755 $tmpfile
su www-data -c $tmpfile

echo "The git setup script has been run"
