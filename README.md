# anki-sync-server

## 1. Why use this repo?

### Official repo from ankicommunity cannot work with python3, and may lose data when update/delete docker containers.

### This repo can be built as a docker image, no extra files.

## 2. Install and run with shell scripts.

``` shell
$   apt/yum/brew install docker. 
$   mkdir /data/anki
```

> All your anki data will safely stored in the local path(/data/anki), don't worry the container will delete itself when it stops.

``` shell
$   curl -O https://github.com/mingwiki/anki-sync-server/releases/download/v1/anki.sh
$   sh anki.sh
```

> Run this shell to start the container every time, you don't have to clone all the repo, just keep this script only.

## 3. Enter docker container and manage anki user.

```shell
$   docker container exec -it anki-server /bin/bash # Enter container
$   ./ankisyncctl.py help   # get commands
$   ./ankisyncctl.py adduser <username> # add a new user
$   ./ankisyncctl.py deluser <username> # delete a user
$   ./ankisyncctl.py lsuser             # list users
$   ./ankisyncctl.py passwd <username>  # change password of a user
```

## 4. Nginx.conf recomended, AnkiDroid is forced to use https.

> Use certbot to get SSL certs for free, if you don't have.

> Use my site "anki.naizi.fun" as an example.

``` shell
$   apt/yum/brew install certbot
$   certbot certonly --standalone -d anki.naizi.fun
```

> Certs will be stored in /etc/letsencrypt/archive, manually copy to nginx path.

``` nginx
server {
    # Allow access via HTTP
    listen 27701;
    listen [::]:27701;

    # Allow access via HTTPS
    listen 443 ssl;
    listen [::]:443 ssl;

    # Set server names for access
    server_name anki.naizi.fun; # Edit this!!!

    # Set TLS certificates to use for HTTPS access
    ssl_certificate certs/anki.naizi.fun.pem; # Edit this!!!
    ssl_certificate_key certs/anki.naizi.fun.key; # Edit this!!!

    location / {
        # Prevent nginx from rejecting larger media files
        client_max_body_size 0;

        proxy_pass http://intranet-ip:27701; # Edit this!!!
    }
```

## 5. AnkiDroid Settings

``` txt
https://anki.naizi.fun/
https://anki.naizi.fun/msync
```

## 6. Build your own docker image on your needs.

``` shell
$   git clone https://github.com/mingwiki/anki-sync-server.git
$   cd anki-sync-server
$   docker build -t anki-sync-server .
```