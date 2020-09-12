docker build -t jackmckew/multi-docker-client:latest -t jackmckew/multi-docker-client:${GITHUB_SHA} -f ./client/Dockerfile ./client
docker build -t jackmckew/multi-docker-server:latest -t jackmckew/multi-docker-server:${GITHUB_SHA} -f ./server/Dockerfile ./server
docker build -t jackmckew/multi-docker-worker:latest -t jackmckew/multi-docker-worker:${GITHUB_SHA} -f ./worker/Dockerfile ./worker

docker push jackmckew/multi-docker-client:latest
docker push jackmckew/multi-docker-server:latest
docker push jackmckew/multi-docker-worker:latest

docker push jackmckew/multi-docker-client:${GITHUB_SHA}
docker push jackmckew/multi-docker-server:${GITHUB_SHA}
docker push jackmckew/multi-docker-worker:${GITHUB_SHA}

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=jackmckew/multi-docker-client:${GITHUB_SHA}
kubectl set image deployments/server-deployment server=jackmckew/multi-docker-server:${GITHUB_SHA}
kubectl set image deployments/worker-deployment worker=jackmckew/multi-docker-worker:${GITHUB_SHA}