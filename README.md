# Ikiwiki Docker Container

This container provides Ikiwiki with:

* Actiontabs theme
* Some useful default plugins
* Config of useful options via environment variables
* Import of an initial git repo with content
* Update content via git + SSH using key auth

For a better idea see the [wiki setup script](https://github.com/abopen/ikiwiki-docker/blob/master/script/ikiwiki-setup.sh).

## Requirements

This Docker image is intended to be used with:

* [nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/).
* [letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion/).
* [docker-gen](https://hub.docker.com/r/mkodockx/docker-gen/).

Other reverse-proxies could be used, but SSL is assumed!

## Builds

[Docker Hub](https://hub.docker.com/r/abopen/ikiwiki/).

### Pull

```bash
$ docker pull abopen/ikiwiki

```
## Environment variables

### Config parameters

#### Required

* VIRTUAL_HOST
* WIKI_NAME

#### Optional

* ADMIN_EMAIL
* ADMIN_USER
* LOCKED_PAGES

Note that the admin user can be created after the wiki is set up.

### Enable/disable features

Set a variable to any value, e.g. `yes`, to activate.

#### Enable additional features

* RSS
* ATOM
* SEARCH
* LOGO (expects a logo to be at `images/logo.png`)

#### Turn off features that are enabled by default 

* NO_DISCUSSION
* NO_EDIT
* NO_RECENTCHANGES
* NO_CGI (editing via git only and no preferences link in the UI)

## Custom templates

Any custom templates should be placed in `templates/` in wikivol.

### Page template with site logo

A custom page template is provided that configures a site logo.
Setting environment variable `LOGO` configures this to be used.
This creates symlink `page.tml` -> `page.tmpl.LOGO`.

A PNG file must be present at `images/logo.png` in the content
git repository.

## Usage examples

### Initial import

First volume is a bind mount to an existing working copy git repo.

If starting out with new content, initialise a repo with `git init`.

  ```
  $ docker run \
    --name ikiwiki \
    -v /path/to/repo:/import \
    -v wikivol:/wiki \
    -d \
    -e VIRTUAL_HOST=domain.wiki \
    -e LETSENCRYPT_HOST=domain.wiki \
    -e WIKI_NAME=myWiki \
    -p 80
    -p 2222:22
    abopen/ikiwiki
  ```

### With an existing populated volume

Once you have a container with wiki content being managed via the web
interface and/or git+SSH, you no longer need the bind mount to /import.

  ```
  $ docker run \
    --name ikiwiki \
    -v wikivol:/wiki \
    -d \
    -e VIRTUAL_HOST=domain.wiki \
    -e LETSENCRYPT_HOST=domain.wiki \
    -e WIKI_NAME=myWiki \
    -p 80
    -p 2222:22
    abopen/ikiwiki
  ```

### Updating via git + SSH

Copy authorized_keys into the wiki volume.

  ```
  $ docker cp authorized_keys wikivol:/wiki/authorized_keys
  ```

Clone the repo as `www-data` and using the appropriate port, e.g.:

  ```
  $ $ git clone ssh://www-data@domain.wiki:2222/wiki/wiki.git myWiki
  ```

Make changes, commit and push.

## Credits

This container is based in part on:

* [ankitrgadiya/docker-ikiwiki](https://github.com/ankitrgadiya/docker-ikiwiki)
* [dgsb/docker-ikiwiki](https://github.com/dgsb/docker-ikiwiki)
