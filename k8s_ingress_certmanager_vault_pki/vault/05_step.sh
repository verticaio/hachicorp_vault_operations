#!/usr/bin/env bash
set -o xtrace
export VAULT_ADDR=http://192.168.0.105
export VAULT_TOKEN=`cat user.token`

#list all certificates created by the intermediate CA
vault list pki_int/certs
vault list pki_int/certs > cert_key_list


cert1=$(sed '3q;d' cert_key_list)
echo $cert1

#read certificate 
vault read  pki_int/cert/${cert1}


#revoke  certificate
vault write pki_int/revoke serial_number=${cert1}

#read the revoked certificate 
vault read  pki_int/cert/${cert1}


#call the tidy API to clen up revoked certs
vault write pki_int/tidy \
   safety_buffer=5s \
    tidy_cert_store=true \
    tidy_revocation_list=true