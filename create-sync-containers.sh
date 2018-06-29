kubectl create -f kubernetes/deployments/backend-sync.yml
kubectl create -f kubernetes/services/backend-sync.yml
kubectl create -f kubernetes/deployments/server-sync.yml
kubectl create -f kubernetes/services/server-sync.yml
kubectl get po
kubectl get services
