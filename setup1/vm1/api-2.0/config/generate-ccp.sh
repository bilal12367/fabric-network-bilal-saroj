#!/bin/bash

rm -f connection-org*.json

sleep 2

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    local PP1=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
    -e "s/\${P0PORT}/$2/" \
    -e "s/\${CAPORT}/$3/" \
    -e "s#\${PEERPEM}#$PP#" \
    -e "s#\${CAPEM}#$CP#" \
    -e "s#\${PEERPEM1}#$PP1#" \
    -e "s#\${P0PORT1}#$7#" \
    ./ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
    -e "s/\${P0PORT}/$2/" \
    -e "s/\${CAPORT}/$3/" \
    -e "s#\${PEERPEM}#$PP#" \
    -e "s#\${CAPEM}#$CP#" \
    organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

function generateCPOrg1(){
    ORG=1
    P0PORT=7050
    CAPORT=7054
    P0PORT1=7051
    PEERPEM=../../crypto-config/peerOrganizations/org${ORG}.example.com/peers/peer0.org${ORG}.example.com/tls/tlscacerts/tls-localhost-${CAPORT}-ca-org${ORG}-example-com.pem
    PEERPEM1=../../crypto-config/peerOrganizations/org${ORG}.example.com/peers/peer1.org${ORG}.example.com/tls/tlscacerts/tls-localhost-${CAPORT}-ca-org${ORG}-example-com.pem
    CAPEM=../../crypto-config/peerOrganizations/org${ORG}.example.com/msp/tlscacerts/ca.crt
    
    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1)" > connection-org${ORG}.json
    #echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1.example.com/connection-org1.yaml
    
}

function generateCPOrg2(){
    ORG=2
    P0PORT=8050
    P0PORT1=8051
    CAPORT=8054
    PEERPEM=../../../vm2/crypto-config/peerOrganizations/org${ORG}.example.com/peers/peer0.org${ORG}.example.com/tls/tlscacerts/tls-localhost-${CAPORT}-ca-org${ORG}-example-com.pem
    PEERPEM1=../../../vm2/crypto-config/peerOrganizations/org${ORG}.example.com/peers/peer1.org${ORG}.example.com/tls/tlscacerts/tls-localhost-${CAPORT}-ca-org${ORG}-example-com.pem
    CAPEM=../../../vm2/crypto-config/peerOrganizations/org${ORG}.example.com/msp/tlscacerts/ca.crt
    
    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1)" > connection-org${ORG}.json
    #echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1.example.com/connection-org1.yaml

}

function generateCPOrg3(){
    ORG=3
    P0PORT=9056
    P0PORT1=9057
    CAPORT=9054
    PEERPEM=../../../vm3/crypto-config/peerOrganizations/org${ORG}.example.com/peers/peer0.org${ORG}.example.com/tls/tlscacerts/tls-localhost-${CAPORT}-ca-org${ORG}-example-com.pem
    PEERPEM1=../../../vm3/crypto-config/peerOrganizations/org${ORG}.example.com/peers/peer1.org${ORG}.example.com/tls/tlscacerts/tls-localhost-${CAPORT}-ca-org${ORG}-example-com.pem
    CAPEM=../../../vm3/crypto-config/peerOrganizations/org${ORG}.example.com/msp/tlscacerts/ca.crt
    
    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1)" > connection-org${ORG}.json
    #echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1.example.com/connection-org1.yaml
}

generateCPOrg1
generateCPOrg2
generateCPOrg3