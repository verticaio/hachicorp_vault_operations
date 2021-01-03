#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#create a new policy to create update revoke and list certificates
vault policy write pki_int pki_int.hcl