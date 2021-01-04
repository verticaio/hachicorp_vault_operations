#!/usr/bin/env bash
set -o xtrace
#stop and remove vault containers if running
docker stop vault-demo-vault test.example.com 
docker rm vault-demo-vault test.example.com

#delete all generated files
rm pki-ca-root.json cert_key_list  ca.pem pki_intermediate.csr intermediate.cert.pem  test.example.com.crt  role_id  secret_id user.token 
rm -rf certs
