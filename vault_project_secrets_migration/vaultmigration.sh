#!/usr/bin/env bash

source=$1
dest=$2

# ensure we were given two command line arguments
if [[ $# -ne 2 ]]; then
  echo 'usage: ./vaultmigration.sh  SOURCE DEST' >&2
  exit 1
fi

echo "Migration started ..."
for repo_name in $(vault kv list secret/$source);  
do 
    for env_name in $(vault kv list secret/$source/$repo_name | tail -n +3);
    do
        #vault  read -format=json secret/data/$source/$repo_name/$env_name | jq .data.data
        vault kv put secret/$dest/$repo_name/$env_name  @<(vault  read -format=json secret/data/$source/$repo_name/$env_name | jq .data.data)
    done
done
