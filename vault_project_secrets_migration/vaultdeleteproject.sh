#!/usr/bin/env bash

project_path=$1

# ensure we were given two command line arguments
if [[ $# -ne 1 ]]; then
  echo 'usage: ./vault-delete.sh  project_path' >&2
  exit 1
fi

echo "Project bulk remove started ..."
for repo_name in $(vault kv list secret/$project_path);  
do 
    echo "Removing $repo_name ..."
    for env_name in $(vault kv list secret/$project_path/$repo_name | tail -n +3);
    do
        echo "Removing $env_name"
        vault  delete   secret/data/$project_path/$repo_name/$env_name
        vault kv  delete  secret/data/$project_path/$repo_name/$env_name
        vault kv metadata delete  secret/$project_path/$repo_name/$env_name
    done
done
