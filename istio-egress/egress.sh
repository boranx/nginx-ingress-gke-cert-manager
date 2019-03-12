#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.0/samples/sleep/sleep.yaml


cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: httpbin-ext
spec:
  hosts:
  - httpbin.org
  ports:
  - number: 80
    name: http
    protocol: HTTP
  resolution: DNS
  location: MESH_EXTERNAL
EOF


cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: google
spec:
  hosts:
  - www.google.com
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  resolution: DNS
  location: MESH_EXTERNAL
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: google
spec:
  hosts:
  - www.google.com
  tls:
  - match:
    - port: 443
      sni_hosts:
      - www.google.com
    route:
    - destination:
        host: www.google.com
        port:
          number: 443
      weight: 100
EOF


export SOURCE_POD=$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})
kubectl exec -it $SOURCE_POD -c sleep sh
curl http://httpbin.org/headers # HTTP
curl https://www.google.com # HTTPS

time curl -o /dev/null -s -w "%{http_code}\n" http://httpbin.org/delay/5


cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: httpbin-ext
spec:
  hosts:
    - httpbin.org
  http:
  - timeout: 3s
    route:
      - destination:
          host: httpbin.org
        weight: 100
EOF

kubectl exec -it $SOURCE_POD -c sleep sh
time curl -o /dev/null -s -w "%{http_code}\n" http://httpbin.org/delay/5


kubectl delete serviceentry httpbin-ext google
kubectl delete virtualservice httpbin-ext google
kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.0/samples/sleep/sleep.yaml