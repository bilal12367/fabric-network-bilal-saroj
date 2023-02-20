echo ---------------Start---------------------

docker rm -f $(docker ps -a -q)

docker volume rm $(docker volume ls -q)

docker network prune 

# docker network create -d bridge artifacts_test 

sleep 2

cd vm1 

./create.sh

sleep 1

cd ../vm2

./create.sh

sleep 1


cd ../vm3

./create.sh

sleep 1

cd ../vm4

./create.sh

sleep 1

cd ../../artifacts/channel

./create-artifacts.sh

cd ../../setup1/vm1

sleep 1

docker-compose up -d

cd ../vm2

sleep 1

docker-compose up -d

cd ../vm3

sleep 1

docker-compose up -d

cd ../vm4

sleep 1

docker-compose up -d

echo ${PWD}

cd ../vm1

sleep 5

./createChannel.sh

sleep 1

cd ../vm2

./joinChannel.sh

sleep 1

cd ../vm3

./joinChannel.sh

sleep 1

cd ../vm1

./deployChaincode.sh

sleep 2

cd ../vm2

./installAndApproveChaincode.sh

sleep 2 

cd ../vm3

./installAndApproveChaincode.sh

cd ../vm1

./deployChaincode2.sh
echo ---------------END---------------------