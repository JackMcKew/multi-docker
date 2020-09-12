docker build -t jackmckew/multi-client:latest -t jackmckew/multi-client:${GITHUB_SHA} -f ./client/Dockerfile ./client
docker build -t jackmckew/multi-server:latest -t jackmckew/multi-server:${GITHUB_SHA} -f ./server/Dockerfile ./server
docker build -t jackmckew/multi-worker:latest -t jackmckew/multi-worker:${GITHUB_SHA} -f ./worker/Dockerfile ./worker

docker push jackmckew/multi-client:latest
docker push jackmckew/multi-server:latest
docker push jackmckew/multi-worker:latest

docker push jackmckew/multi-client:${GITHUB_SHA}
docker push jackmckew/multi-server:${GITHUB_SHA}
docker push jackmckew/multi-worker:${GITHUB_SHA}

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=jackmckew/multi-client:${GITHUB_SHA}
kubectl set image deployments/server-deployment server=jackmckew/multi-server:${GITHUB_SHA}
kubectl set image deployments/worker-deployment worker=jackmckew/multi-worker:${GITHUB_SHA}