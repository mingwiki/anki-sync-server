# anki-sync-server

## 1. Why use this repo?

### official repo from ankicommunity cannot work with python3, and the tutoral is too complex.

## 2. User data and configuration

### All user data is stored in ./data folder. The config file is "ankisyncd.conf"

## 4. Install and run with shell scripts.

`mkdir /data/anki` 

### All your anki data will stored in the local path, don't worry the container will delete itself when it stops. Of course, make sure docker pre-installed already， usually apt/ yum/ brew install docker. 
`sh anki.sh`

### Keep and run this shell to start the container every time, you don't have to clone all the repo, keep this script only.

### -d: run in background

### -rm: delete container when stop

### --name: container name

### -p: Map localhost port to container port

### -v: Mount localhost path to container path

## 5. Build your own docker image on your needs.

`cd anki-sync-server`

`docker build -t anki-sync-server .`
