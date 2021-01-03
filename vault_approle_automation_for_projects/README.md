# Create secrets, policy, approle and auth, k8s secret files and apply k8s

```
chmod +x vault_create_project.sh
./vault_create_project.sh  project_name

Bulk import started ...
dev enviroment:
--- Policy file generating ..
--- Policy creating ..
Success! Uploaded policy: test_project_dev
--- Approle auth method binding to policy..
Success! Data written to: auth/approle/role/test_project_dev
--- Approle Auth secrets generating:
RoleID: 18decebc-c0dasd25-4dd3-dd16-28e690826035 
SecretID: c1412bf3-98das2e-33c9-3114-a849f3fd426b 
--- K8s  secrets generating:
export k8s env 
kubectl apply -f ./secrets_k8s/test_project_dev_secret.yaml
--- Get  temporary token for checking vault secret access from Vault UI:
s.bEnX5Kv2e6das68aeP9HsSmWioL 


preprod enviroment:
--- Policy file generating ..
--- Policy creating ..
Success! Uploaded policy: test_project_preprod
--- Approle auth method binding to policy..
Success! Data written to: auth/approle/role/test_project_preprod
--- Approle Auth secrets generating:
RoleID: 8912adae44-5ae2-db37-4644-de09acd293f3 
SecretID: 86f4ada207-5644-006f-8738-604190b00a89 
--- K8s  secrets generating:
export k8s env 
kubectl apply -f ./secrets_k8s/test_project_preprod_secret.yaml
--- Get  temporary token for checking vault secret access from Vault UI:
s.6BzLIWS0Mo3Yzdasop77dRILRtL 


prod enviroment:
--- Policy file generating ..
--- Policy creating ..
Success! Uploaded policy: test_project_prod
--- Approle auth method binding to policy..
Success! Data written to: auth/approle/role/test_project_prod
--- Approle Auth secrets generating:
RoleID: 4dd5bdas499-663b-4d36-b238-3321f39fbd03 
SecretID: f637cdase9a-6e81-aa1a-5206-571670f6faf5 
--- K8s  secrets generating:
export k8s env 
kubectl apply -f ./secrets_k8s/test_project_prod_secret.yaml
--- Get  temporary token for checking vault secret access from Vault UI:
s.1YjTm5LKXQTqWdas1iWiTOUNSbK
```