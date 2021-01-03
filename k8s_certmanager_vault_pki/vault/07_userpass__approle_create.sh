#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost
export VAULT_TOKEN=root
export VAULT_NAMESPACE=
#enable approle to create an authentication method for creating and managing the certificates
vault auth enable approle
vault write auth/approle/role/cert-manager-role policies=pki_int
vault read auth/approle/role/cert-manager-role/role-id > role_id
vault write -f auth/approle/role/cert-manager-role/secret-id > secret_id