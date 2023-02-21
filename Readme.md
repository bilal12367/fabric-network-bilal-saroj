# Hyperledger Fabric - Network Setup Documentation


Basic Project Structure
```
📦fabric-network
 ┣ 📂artifacts
 ┗ 📂setup1
    ┣ 📂vm1
    ┣ 📂vm2
    ┣ 📂vm3
    ┗ 📂vm4
```

# Generating Certificates
## Generating Artifacts for VM1
1. Create directory and docker-compose file inside vm1 as shown below

```
📂setup1
    ┗ 📂vm1
        ┗ 📂create-certificate-with-ca
           ┗ 🐳docker-compose.yaml
```

2. Docker compose file for the certificate authority.
```yaml
version: '3'

networks:
  test:

# Replace ORG_NAME with organization name
# Replace ORG_PORT with organization port

services:
  ca_org1:
    image: hyperledger/fabric-ca
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME= ca.<ORG_NAME>.example.com
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT= <ORG_PORT>
    ports:
      - "<ORG_PORT>:<ORG_PORT>"
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./fabric-ca/org1:/etc/hyperledger/fabric-ca-server
    container_name: ca.<ORG_NAME>.example.com
    hostname: ca.<ORG_NAME>.example.com
    networks:
      - test

```
3. Docker compose up the file using
> docker-compose up -d

4. Check the directory it will create fabric-ca folder as shown below inside vm1.

```
📂setup1
    ┗ 📂vm1
        ┣  📂fabric-ca
        ┣    ┗ 📂org1
        ┣       ┣ 📂msp
        ┣       ┣ 📂cacerts
        ┣       ┣ 📂keystore
        ┣       ┣ 📂signcerts
        ┣       ┗ 📂user
        ┗ 📂create-certificate-with-ca
           ┗ 🐳docker-compose.yaml
```
5. Create shell file create-certificate-with-ca.sh inside vm1 as shown below.
```
📂setup1
    ┗ 📂vm1
        ┣  📂fabric-ca
        ┣    ┗ 📂org1
        ┣       ┣ 📂msp
        ┣       ┣ 📂cacerts
        ┣       ┣ 📂keystore
        ┣       ┣ 📂signcerts
        ┣       ┗ 📂user
        ┗ 📂create-certificate-with-ca
           ┣ 🐳docker-compose.yaml
           ┗ 📜create-certificate-with-ca.sh
```

6. First create a basic function and call it in the end.

7. Make directory for the organization using the following command.


```bash
# For Peer Organization
mkdir -p ../crypto-config/peerOrganizations/${ORG_NAME}/
# For Orderer Organization
mkdir -p ../crypto-config/ordererOrganizations/${ORG_NAME}/
```
8. Export **FABRIC_CA_CLIENT_HOME**  to the organization directory.

```bash
export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/${ORG_NAME}/
```

9. Enroll Admin using the following command.

```bash
fabric-ca-client enroll -u https://admin:adminpw@localhost:${ORG_PORT} --caname ca.${ORG_NAME} --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
```

10. Copy NodeOUs configuration to the organization msp directory creating config.yaml path

```bash
echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/config.yaml
```

11. Registering the peers

Example for 2 peers organization
```bash  
  echo
  echo "Registering peer0"
  echo

  fabric-ca-client register --caname ca.org1.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  echo
  echo "Registering peer1"
  echo

  fabric-ca-client register --caname ca.org1.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  echo
  echo "Registering user"
  echo

  fabric-ca-client register --caname ca.org1.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  echo
  echo "Registering admin"
  echo
```

Syntax for registering the peer, user and admin

```bash
    fabric-ca-client register --caname <ORG_NAME> --id.name <IDName> --id.secret <IDPassword> --id.type< peer | user |admin > --tls.certfiles <path to tls-cert.pem>

📦fabric-ca
 ┗ 📂org1
   ┣ 📂msp
   ┗ 📜tls-cert.pem  <--- Tls cert file
```

12. Create crypto-config and peers directory inside the organization folder.

```
📦crypto-config
 ┗ 📂peerOrganizations
 ┃ ┗ 📂org1.example.com
     ┣ 📂ca
     ┣ 📂msp
   ┃ ┃ ┣ 📂cacerts
   ┃ ┃ ┣ 📂keystore
   ┃ ┃ ┣ 📂signcerts
   ┃ ┃ ┣ 📂tlscacerts
   ┃ ┃ ┣ 📂user
     ┗ 📂peers
```

13. Generating peer msp
```bash
fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0.org1.example.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
```
Syntax
```bash
fabric-ca-client enroll -u <URL of CA> --caname <CA Name> -M <MSP Directory> --csr.hosts <Peer Name> --tls.certfiles <Path to tls cert file of CA>
```
This will generate msp inside peer folder.

```
📦crypto-config
 ┗ 📂peerOrganizations
   ┗ 📂org1.example.com
     ┣ 📂ca
     ┣ 📂msp
     ┣ 📂cacerts
     ┣ 📂keystore
     ┃ ┣ 📂signcerts
     ┃ ┣ 📂tlscacerts
     ┃ ┗ 📂user
     ┗ 📂peers
       ┗ 📂peer0.org1.example.com
         ┗ 📂msp
           ┣ 📂cacerts
           ┣ 📂keystore
           ┣ 📂signcerts
           ┗ 📂user
```
14. Generating peer tls

```bash
fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
```

syntax
```bash
fabric-ca-client enroll -u <CA Url> --caname <CA Name> -M <tls folder path> --enrollment.profile tls --csr.hosts <Peer Name> --csr.hosts localhost --tls.certfiles <path to TLS certfile>
```

This will generate tls folder inside the peer directory.

```
📦crypto-config
 ┗ 📂peerOrganizations
   ┗ 📂org1.example.com
     ┣ 📂ca
     ┣ 📂msp
     ┣ 📂cacerts
     ┣ 📂keystore
     ┃ ┣ 📂signcerts
     ┃ ┣ 📂tlscacerts
     ┃ ┣ 📂user
     ┣ 📂peers
     ┃ ┣ 📂peer0.org1.example.com
     ┃ ┃ ┣ 📂msp
     ┃ ┃ ┃ ┣ 📂cacerts
     ┃ ┃ ┃ ┣ 📂keystore
     ┃ ┃ ┃ ┣ 📂signcerts
     ┃ ┃ ┃ ┣ 📂user
     ┃ ┃ ┗ 📂tls           <=== tls folder generated
     ┃ ┃   ┣ 📂cacerts
     ┃ ┃   ┣ 📂keystore
     ┃ ┃   ┣ 📂signcerts
     ┃ ┃   ┣ 📂tlscacerts
     ┃ ┃   ┗ 📂user
```

15. Copy the certfiles and make it available inside tls folder of peer directory.

```bash
cp ${PWD}/../crypto-config/peerOrganizations/org1.../tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.../tls/ca.crt

cp ${PWD}/../crypto-config/peerOrganizations/org1.../tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org1..../tls/server.crt


cp ${PWD}/../crypto-config/peerOrganizations/org1.../tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.../tls/server.key
```

```
../tls/tlscacerts/* ==> ../tls/ca.crt
../tls/signcerts/* ==> ../tls/server.crt
../tls/keystore/* ==> ../tls/server.key
```

16. Copying certfiles from anchor peer to orgnaization folder.

    *a.* Make the following directories
    ```bash
    mkdir ${PWD}/crypto-config/.../org1.example.com/msp/tlscacerts
    mkdir ${PWD}/crypto-config/.../org1.example.com/tlsca
    mkdir ${PWD}/crypto-config/.../ca
    ```
    *b.* Now copy these files to these directories
    ```bash
    cp peer0.org1.example.com/tls/tlscacerts/* /org1.example.com/msp/tlscacerts/ca.crt
    cp peer0.org1.example.com/tls/tlscacerts/* /org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
    cp peer0.org1.example.com/tls/cacerts/* /org1.example.com/ca/ca.org1.example.com-cert.pem
    ```
```
📦crypto-config
 ┗ 📂peerOrganizations
   ┗ 📂org1.example.com
     ┣ 📂ca
     ┣ 📂msp
     ┣ 📂cacerts
     ┣ 📂keystore
     ┃ ┣ 📂signcerts
     ┃ ┣ 📂tlscacerts
     ┃ ┣ 📂user
     ┣ 📂peers
     ┃ ┣ 📂peer0.org1.example.com
     ┃ ┃ ┣ 📂msp
     ┃ ┃ ┃ ┣ 📂cacerts
     ┃ ┃ ┃ ┣ 📂keystore
     ┃ ┃ ┃ ┣ 📂signcerts
     ┃ ┃ ┃ ┣ 📂user
     ┃ ┃ ┗ 📂tls
     ┃ ┃   ┣ 📂cacerts
     ┃ ┃   ┣ 📂keystore
     ┃ ┃   ┣ 📂signcerts
     ┃ ┃   ┣ 📂tlscacerts
     ┃ ┃   ┗ 📂user
     ┃ ┗ 📂peer1.org1.example.com
     ┃   ┣ 📂msp
     ┃   ┃ ┣ 📂cacerts
     ┃   ┃ ┣ 📂keystore10d9414f8c599e2ab67083bc9f512061c534d_sk
     ┃   ┃ ┣ 📂signcerts
     ┃   ┃ ┣ 📂user
     ┃   ┗ 📂tls
     ┃     ┣ 📂cacerts
     ┃     ┣ 📂keystore
     ┃     ┣ 📂signcerts
     ┃     ┣ 📂tlscacerts
     ┃     ┣ 📂user
     ┣ 📂tlsca
     ┗ 📂users
```





