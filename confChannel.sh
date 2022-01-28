#!/bin/bash
echo $PWD
echo "####################################################### "
echo "#Creación del canal# "
echo "####################################################### "
export CHANNEL_NAME=evoting
peer channel create -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

echo "####################################################### "
echo "           Añadir organizaciones al canal "
echo "####################################################### "
# Peer0 Org1
peer channel join -b evoting.block
# Peer1 Org1
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/users/Admin@org1.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org1.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/peers/peer0.org1.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer1.org2.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer1.org3.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org4
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer0.org4.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org4
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer1.org4.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org5
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer0.org5.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org5
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer1.org5.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org6
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer0.org6.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org6
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer1.org6.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org7
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer0.org7.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org7
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer1.org7.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer0 Org8
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer0.org8.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block
# Peer1 Org8
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer1.org8.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

echo "####################################################### "
echo "            Configuración de AnchorPeers "
echo "####################################################### "
# Org1
peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
# Org2

# Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org3MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
# Org4
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer0.org4.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org4MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
# Org5
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer0.org5.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org5MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
# Org6
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer0.org6.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org6MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
# Org7
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer0.org7.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org7MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
# Org8
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer0.org8.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org8MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
