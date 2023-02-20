

createcertificatesFororg3(){

  echo 'hello world'

  mkdir -p ../crypto-config/peerOrganizations/org3.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org3.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca.org3.example.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../crypto-config/peerOrganizations/org3.example.com/msp/config.yaml

  
  echo
  echo "Registering peer0"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  echo
  echo "Registering peer1"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  echo
  echo "Registering user"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  echo
  echo "Registering admin"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name org3admin --id.secret org3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem


  mkdir -p ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers


  # ---------------------------------------------------------------------------------------------------------------------------------------
  # Peer 0
  echo
  echo "Generating Peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.org3.example.com -M ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp --csr.hosts peer0.org3.example.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/config.yaml

  echo
  echo "Generating peer0 tls"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.org3.example.com -M ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls --enrollment.profile tls --csr.hosts peer0.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/msp/tlscacerts/ca.crt
  
  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/ca/ca.org3.example.com-cert.pem

  # ---------------------------------------------------------------------------------------------------------------------------------------
  # Peer 1

  echo
  echo "Generating Peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.org3.example.com -M ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp --csr.hosts peer1.org3.example.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/config.yaml

  echo
  echo "Generating peer1 tls"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.org3.example.com -M ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls --enrollment.profile tls --csr.hosts peer1.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/server.key

  mkdir -p ../crypto-config/peerOrganizations/org3.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/org3.example.com/users/User1@org3.example.com
  # ---------------------------------------------------------------------------------------------------------------------------------------
  # User And Admin

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca.org3.example.com -M ${PWD}/../crypto-config/peerOrganizations/org3.example.com/users/User1@org3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org3admin:org3adminpw@localhost:9054 --caname ca.org3.example.com -M ${PWD}/../crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/config.yaml

}

createcertificatesFororg3





