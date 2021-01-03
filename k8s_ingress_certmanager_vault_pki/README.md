# Kubernetes Ingress SSL/TLS Automation for Apps - PKI as a Service with Vault and Cert Manager

## What we want to achieve

## Design Consideration 

## Tools I use for demo purposes:
[Kind](https://kind.sigs.k8s.io) - tool for running local Kubernetes clusters using Docker container “nodes”.<br/>
[Cert-Manager](https://cert-manager.io/docs/) -  native Kubernetes certificate management controller<br/>
[Vault](https://www.vaultproject.io) - Secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API<br/>
[Docker](https://www.docker.com) - Help developers and development teams build and ship apps<br/>
[consul-emplate](https://github.com/hashicorp/consul-template) - The daemon consul-template queries a Consul or Vault cluster and updates any number of specified templates on the file system. As an added bonus, it can optionally run arbitrary commands when the update process completes

### Warning 
There some k8s apis, vault, cert-manager versions may not be supported for your exist environment.Approle role id is not supported as k8s secret in cert-manager issuer api.

## Start Kind k8s cluster
``` 
kind create cluster
kubectl cluster-info --context kind-kind
alias kubectl='kubectl  --context kind-kind'
kubectl create ns  ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod   --selector=app.kubernetes.io/component=controller  --timeout=90s
```

## Start Vault, Enable pki engine and approle authentication mechanism
``` 
Root CA - For the purpose of this demo, we’ll generate our own Root Certificate Authority within Vault. In a production environment, you should use an external Root CA to sign the intermediate CA that Vault will use to generate certificates


Now that we have our Root CA ready, we can enable and configure an Intermediate CA authority on a different path. Everything relates to a PATH within Vault, so here we enable the same secret engine with a different configuration at a different PATH
```

## Install Nginx Ingress, Cert-Manager and Sample-app which enabled https 
``` 
``` 

## References:
[What is PKI](https://securityboulevard.com/2020/02/what-is-pki-a-crash-course-on-public-key-infrastructure-pki/)<br/>
[PKI Fundamentals video](https://www.youtube.com/watch?v=GQVSpHDfW4s)<br/>
[Configure CA in Linux](https://jamielinux.com/docs/openssl-certificate-authority/introduction.html)<br/>
[Configure CA in Windows](https://www.vkernel.ro/blog/building-a-three-tire-windows-certification-authority-hierarchy)<br/>
[Certificate Revocation List](https://en.wikipedia.org/wiki/Certificate_revocation_list)<br/>
[Online-certificate-status-protocol-ocsp-responder](https://www.vkernel.ro/blog/installing-and-configuring-a-microsoft-online-certificate-status-protocol-ocsp-responder)<br/>
[Practical-implementation-of-public-key-infrastructure](https://medium.com/cermati-tech/practical-implementation-of-public-key-infrastructure-at-cermati-104895d0692b)<br/>
[How-to-build-your-own-public-key-infrastructure](https://blog.cloudflare.com/how-to-build-your-own-public-key-infrastructure/)<br/>
[Vault PKI Engine](https://learn.hashicorp.com/tutorials/vault/pki-engine)<br/>
[Vault PKI](https://www.vaultproject.io/api-docs/secret/pki)<br/>
[Certificate-management-with-vault](https://www.hashicorp.com/blog/certificate-management-with-vault)<br/>
[Vault Approle Example](https://gist.github.com/greenbrian/5be10eb2c978a153a52caa9fadbc3b9c)<br/>
[Pki-as-a-service-with-hashicorp-vault-consul-template](https://medium.com/hashicorp-engineering/pki-as-a-service-with-hashicorp-vault-a8d075ece9a)<br/>
[Kubernetes Cert Manager](https://learn.hashicorp.com/tutorials/vault/kubernetes-cert-manager?in=vault/kubernetes)<br/>
[Demo Vault PKI Secret Engine Video](https://www.youtube.com/watch?v=4cEWxROsgW4&list=PL1NUqHkXctOMf7UbgVjnpJ1YdlgVm0DOS&index=2)<br/>
[Openshift CertManager Vault PKI](https://itnext.io/adding-security-layers-to-your-app-on-openshift-part-6-pki-as-a-service-with-vault-and-cert-e6dbbe7028c7)<br/>
[Dynamic-cer-management-with-k8s-cert-manager-and-vault-pki](https://medium.com/@selfieblue/dynamic-certificate-management-with-kubernetess-cert-manager-and-vault-pki-engine-d9ca4759512)<br/>
[Use-vault-pki-engine-for-dynamic-tls-certificates-on-GKE](https://www.arctiq.ca/our-blog/2019/4/1/how-to-use-vault-pki-engine-for-dynamic-tls-certificates-on-gke/)<br/>
[Consul-template-to-automate-certificate-management-vault-pki](https://tekanaid.com/posts/consul-template-to-automate-certificate-management-for-hashicorp-vault-pki/) <br/>
[Hashicorp-vault-pki-secrets-engine-demo-for-certificate-management](https://tekanaid.com/posts/hashicorp-vault-pki-secrets-engine-demo-for-certificate-management/)<br/>
[Securing Kafka with Vault PKI](https://www.youtube.com/watch?v=UajA8UftgfE)<br/>
[Vault to quickly and securely generate PKI (x509) and SSH certificates](https://www.hashicorp.com/resources/streamline-certificate-management-with-vault)<br/>
[Kubernetes-CertManager-Ingress-Nginx](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes)<br/>
[Secure-kubernetes-with-vault](https://koudingspawn.de/secure-kubernetes-with-vault/)<br/>
[Generate-cert-kubeadm-vault](https://banzaicloud.com/blog/generate-cert-kubeadm-vault/)<br/>
[Vault-and-kubernetes](https://www.digitalocean.com/blog/vault-and-kubernetes/)<br/>
[Istio with Vault-CA](https://istio.io/v1.2/docs/tasks/security/vault-ca/)<br/>
