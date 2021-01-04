#!/usr/bin/env bash
set -o xtrace
export VAULT_ADDR=http://192.168.0.105
#set roleid and secretid as env variables from the previous step
role_id=$(cat role_id)
secret_id=$(cat secret_id)

curl -s  --request POST --data '{"role_id": "'"$role_id"'", "secret_id":"'"$secret_id"'"}'  ${VAULT_ADDR}/v1/auth/approle/login |  jq -r ".auth.client_token"  > user.token

#store the token as env variable, now this token can be used to authenticate against Vault
export VAULT_TOKEN=`cat user.token`

#Use the new token to generate a new certificate and store it in a file
vault write -format=json pki_int/issue/example-dot-com common_name=test.example.com > test.example.com.crt

#extract the certificate, issuing ca(intermediate) in the pem file and private key in the key file seperately
cat test.example.com.crt | jq -r .data.certificate > ./certs/test.example.pem
cat test.example.com.crt | jq -r .data.issuing_ca >> ./certs/test.example.pem
cat test.example.com.crt | jq -r .data.private_key > ./certs/test.example.key