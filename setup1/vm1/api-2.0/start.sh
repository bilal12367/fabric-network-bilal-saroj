docker rm -f artifacts_nodeapp_1

docker image rm testnode1

docker-compose up -d

docker logs --follow artifacts_nodeapp_1