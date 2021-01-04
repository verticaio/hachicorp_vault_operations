#!/usr/bin/env bash
set -o xtrace
export VAULT_ADDR=http://192.168.0.105
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#enable Vault PKI secret engine 
vault secrets enable pki

#set default ttl
vault secrets tune -max-lease-ttl=87600h pki

#generate root CA
vault write -format=json pki/root/generate/internal common_name="example.com Root Authority" ttl=8760h > pki-ca-root.json

#save the certificate in a sepearate file, we will add it later as trusted to our browser/computer
cat pki-ca-root.json | jq -r .data.certificate > ca.pem

#publish urls for the root ca
vault write pki/config/urls issuing_certificates="http://192.168.0.105/v1/pki/ca" crl_distribution_points="http://192.168.0.105/v1/pki/crl"

#enable pki secret engine for intermediate CA
vault secrets enable -path=pki_int pki

#set default ttl
vault secrets tune -max-lease-ttl=43800h pki_int

#create intermediate CA with common name example.com and 
#save the CSR (Certificate Signing Request) in a seperate file
vault write -format=json pki_int/intermediate/generate/internal common_name="example.com Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr

#send the intermediate CA's CSR to the root CA for signing
#save the generated certificate in a sepearate file         
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem

#publish the signed certificate back to the Intermediate CA
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

#publish the intermediate CA urls
vault write pki_int/config/urls issuing_certificates="http://192.168.0.105/v1/pki_int/ca" crl_distribution_points="http://192.168.0.105/v1/pki_int/crl"