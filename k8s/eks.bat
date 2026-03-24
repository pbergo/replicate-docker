eksctl create cluster --name qre-production --region us-east-1 --nodegroup-name standard-nodes --node-type t3.medium --nodes 2


login
aws configure

aws eks update-kubeconfig --region us-east-1 --name qre-production

kubectl apply -f qre202511-pwd.yaml
kubectl apply -f qre202511-cfg.yaml
kubectl apply -f qre202511-pvc.yaml
kubectl apply -f qre202511-svi.yaml
kubectl apply -f qre202511-svc.yaml
kubectl apply -f qre202511-sts.yaml
