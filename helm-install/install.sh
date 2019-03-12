#!/bin/bash

kubectl apply -f helm-rbac.yaml
helm init --service-account tiller --upgrade 
kubectl -n kube-system get pods -l name=tiller