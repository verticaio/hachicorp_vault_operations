#!/bin/sh
set -o xtrace
#stop and remove vault containers if already running
docker stop vault-demo-vault
docker rm vault-demo-vault
#start Vault in dev mode on port 8200
location=$(pwd)
mkdir web-server/certs certs
docker network create  dev-network
docker run --name vault-demo-vault -v ${location}/log:/var/log --network dev-network -p 80:8200 vault:1.4.0 server -dev -dev-root-token-id="root" &
