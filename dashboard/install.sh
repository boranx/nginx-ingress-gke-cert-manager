kubectl apply -f dashboard.yaml && sleep 5
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')