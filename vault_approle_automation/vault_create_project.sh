#!/usr/bin/env bash

project_name=$1
vault_address='http://localhost:8200'
declare -a env_name=("dev" "preprod" "prod" )

# ensure we were given two command line arguments
if [[ $# -ne 1 ]]; then
  echo 'usage: ./vault_create_project.sh  project_name' >&2
  exit 1
fi
# Create temp dreictory when program exit delete it automaticly 
tmp=$(mktemp -d)
trap "{ rm -rf $tmp; }" EXIT

# check jq installed
command=$(which jq 2> /dev/null)
if [ -z $command ]
then
    echo "jq command could not be found, exiting ..."
    exit
fi

echo "Bulk import started ..."
if [ ! -z "$(ls -A ./secrets_vault)" ]; then
    for repo_name in $(ls ./secrets_vault);
    do
        for env in $(ls ./secrets_vault/$repo_name);
        do
            env=$(echo $env | awk -F'.' '{print $1}')
            vault kv put  secret/$project_name/$repo_name/$env @secrets_vault/$repo_name/${env}.json
        done
    done
else
   echo "secrets_vault directory is empty"
fi

# check env files exist and default k8s secret exist, will be added
for env in  ${env_name[@]};
do 
    echo -e "$env enviroment:"
    echo "--- Policy file generating .."
    policy_file=$tmp/${env}_policy
    cat ./policies/$env.hcl | sed  -e "s/env_name/$env/g" -e "s/project_name/$project_name/g" > $policy_file

    echo "--- Policy creating .."
    vault policy write ${project_name}_${env}  $policy_file

    echo "--- Approle auth method binding to policy.."
    vault write auth/approle/role/${project_name}_${env}  bind_secret_id="true" policies="${project_name}_${env}"

    echo "--- Approle Auth secrets generating:"
    role_id=$(vault read -format=json auth/approle/role/${project_name}_${env}/role-id | jq '.data.role_id' | sed -e 's/^"//' -e 's/"$//')
    secret_id=$(vault write -f -format=json auth/approle/role/${project_name}_${env}/secret-id | jq '.data.secret_id' |  sed -e 's/^"//' -e 's/"$//')
    echo -e "RoleID: $role_id \nSecretID: $secret_id "
    
    echo "--- K8s  secrets generating:"
    role_id_base64=$(echo -n "$role_id" | base64)
    secret_id_base64=$(echo -n "$secret_id" | base64)
    cat ./secrets_k8s/secret.yaml | sed  -e "s/role_id/$role_id_base64/g" -e "s/secret_id/$secret_id_base64/g" -e "s/project_name/$project_name/g"  > ./secrets_k8s/${project_name}_${env}_secret.yaml
    echo -e "export k8s env \nkubectl apply -f ./secrets_k8s/${project_name}_${env}_secret.yaml"
  
    echo "--- Get  temporary token for checking vault secret access from Vault UI:"    
    token=$(curl -s  --request POST --data '{"role_id": "'"$role_id"'", "secret_id":"'"$secret_id"'"}'  ${vault_address}/v1/auth/approle/login |  jq -r ".auth.client_token")
    echo -e "$token \n"
done
