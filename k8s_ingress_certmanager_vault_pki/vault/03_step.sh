#!/usr/bin/env bash
set -o xtrace
export VAULT_ADDR=http://192.168.0.105
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#create a role to generate new certificates
vault write pki_int/roles/example-dot-com allowed_domains="example.com" allow_subdomains=true max_ttl="720h"

#vault delete pki_int/roles/example-dot-com

#create a new policy to create update revoke and list certificates
vault policy write pki_int pki_int.hcl

#enable approle to create an authentication method for creating and managing the certificates
vault auth enable approle
vault write auth/approle/role/cert-manager-role policies=pki_int
vault read -format=json auth/approle/role/cert-manager-role/role-id | jq '.data.role_id' | sed -e 's/^"//' -e 's/"$//' > role_id
vault write -f -format=json auth/approle/role/cert-manager-role/secret-id | jq '.data.secret_id' |  sed -e 's/^"//' -e 's/"$//' > secret_id