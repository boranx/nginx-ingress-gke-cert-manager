# Nginx ingress - Gke - Cert manager

In this example, we will create secure http endpoints for our services.
Via deploying cert-manager and nginx-ingress on GKE to obtain SSL certificates from Lets Encrypt

* Install Helm

```shell
cd helm-install && ./install.sh
```

* Deploy Dashboard

```shell
cd dashboard && ./install.sh
kubectl proxy --port=8080 --address 0.0.0.0
```

* Deploy Cert Manager via helm

```shell
git clone -b 'v0.2.3' --single-branch --depth 1 https://github.com/jetstack/cert-manager
helm install --name cert-manager contrib/charts/cert-manager --set ingressShim.extraArgs='{--default-issuer-name=letsencrypt-prod,--default-issuer-kind=ClusterIssuer}' --set ingressShim.enabled=false --namespace kube-system
kubectl -n kube-system get pods
```

* Deploy Nginx Ingress via helm

```shell
helm install --name ingress-my-test-app stable/nginx-ingress --set rbac.create='true'
```

* Obtain the External IP, head over to the DNS provider and point DNS to IP adress

```shell
kubectl get svc -l app=nginx-ingress,component=controller -o=jsonpath='{$.items[*].status.loadBalancer.ingress[].ip}'
```

* Ping till it routes to the right IP.

* Deploy Issuer, Certificate, Ingress conf

```shell
cd issuer-letsencrtypt
kubectl apply -f issuer.yaml
kubectl apply -f certificate.yaml
kubectl apply -f ingress.yaml
```

* Deploy Ingress and applications

```shell
cd demo-api && kubectl apply -f deployment.yaml
cd test-api && kubectl apply -f deployment.yaml
```

------------

Type :  
    test.boran.fun/all  
    demo.boran.fun/all  