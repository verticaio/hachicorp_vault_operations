{
  "path":{
    "secret/*":{"capabilities":["list"]},
    "secret/data/project_name/+/env_name":{"capabilities":["read", "list", "update", "create", "delete"]},
    "secret/data/project_name":{"capabilities":["read", "list", "update", "create", "delete"]},
    "secret/data/project_name/env_name":{"capabilities":["read", "list", "update", "create", "delete"]}
  }
}