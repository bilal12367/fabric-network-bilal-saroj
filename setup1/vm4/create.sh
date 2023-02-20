docker rm -f ca_orderer

rm -rf ${PWD}/create-certificate-with-ca/fabric-ca

rm -rf ${PWD}/crypto-config

cd create-certificate-with-ca

echo ${PWD}

docker-compose up -d

sleep 2

./create-certificate-with-ca.sh