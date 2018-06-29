kubectl create -f kubernetes/deployments/backend-async.yml
kubectl create -f kubernetes/services/backend-async.yml
kubectl create -f kubernetes/deployments/server-async.yml
kubectl create -f kubernetes/services/server-async.yml
kubectl get po
kubectl get services
