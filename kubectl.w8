#!/bin/sh

echo "wait on the K8S cluster to become available"

for i in {1..150}; do # timeout for 5 minutes
   ./kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done

echo "kubectl commands are now able to interact with Minikube cluster"
kubectl get po
