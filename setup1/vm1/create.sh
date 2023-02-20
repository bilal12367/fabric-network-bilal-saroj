docker rm -f ca.org1.example.com

rm -rf ${PWD}/create-certificate-with-ca/fabric-ca

rm -rf ${PWD}/crypto-config

cd create-certificate-with-ca

echo ${PWD}

docker-compose up -d

sleep 2

./create-certificate-with-ca.sh