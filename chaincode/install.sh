#Business Blockchain Training & Consulting SpA. All Rights Reserved.
#www.blockchainempresarial.com
#email: ricardo@blockchainempresarial.com

echo "########################################################"
echo "#            Creación de variables globales            #"
echo "########################################################"

export CHANNEL_NAME=evoting
export CHAINCODE_NAME=evoting
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/${CHAINCODE_NAME}/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

#Descarga dependencias
#export FABRIC_CFG_PATH=$PWD/configtx
#pushd ../chaincode/$CHAINCODE_NAME
#GO111MODULE=on go mod vendor
#popd

echo "#######################################################"
echo "#        Empauqetar el chaincode en ejecutable        #"
echo "#######################################################"

#Empaqueta el chaincode
# peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >&logs.txt

# Si da error puede ser por que falta el archivo go.sum o go.mod se debe tener
# go.mod en la carpeta del chaincode y en esa carpeta se debe ejecutar el comando
# go mod tidy
# esto creará el archivo go.sum

echo "##########################################################"
echo "#            Instalar Chaincode en peer0.org0            #"
echo "##########################################################"

#peer lifecycle chaincode install example
#first peer peer0.org1.ibcn.unl.edu.ec
# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

#Actualizar este  valor con el que obtengan al empaquetar el chaincode: evoting_1:4e3ed2c8980cbf90d244fa2b0a8d448df4d4ee25255be6f234f47dd83d9a1a65
echo 'Introduzca el valor que aparece en "Chaincode code package identifier":'
#leer el dato del teclado y guardarlo en la variable de usuario var1
read var1
#Mostrar el valor de la variable de usuario
# export CC_PACKAGEID=$var1
# echo $CC_PACKAGEID
echo $var1
echo
export CC_PACKAGEID=evoting_1:4e3ed2c8980cbf90d244fa2b0a8d448df4d4ee25255be6f234f47dd83d9a1a65

echo "##########################################################"
echo "#            Instalar Chaincode en peer*.org*            #"
echo "##########################################################"

# Peer1 Org1
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/users/Admin@org1.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org1.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/peers/peer1.org1.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer1.org2.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer1.org3.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org4
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer0.org4.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org4
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer1.org4.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org5
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer0.org5.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org5
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer1.org5.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org6
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer0.org6.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org6
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer1.org6.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org7
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer0.org7.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org7
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer1.org7.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer0 Org8
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer0.org8.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz
# Peer1 Org8
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer1.org8.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz

echo "##########################################################"
echo "#               Politicas de Endorsamiento               #"
echo "##########################################################"

# PEER0 ORG1
#Endorsement policy for lifecycle chaincode

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGEID

#2020-09-03 17:39:05.756 UTC [chaincodeCmd] ClientWait -> INFO 046 txid [453ed408b77c198d7159904c94b8d44b4d7633273f200bafc87c5419901883c2] committed with status (ENDORSEMENT_POLICY_FAILURE) at peer0.org1.ibcn.unl.edu.ec:7051
#Error: transaction invalidated with status (ENDORSEMENT_POLICY_FAILURE)

# PEER1 ORG1

#Let Org3 approve the chaincode package.
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/users/Admin@org1.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org1.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/peers/peer1.org1.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGEID

# Peer0 Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGEID

# Peer1 Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer1.org2.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGEID

# Peer0 Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGEID

# Peer1 Org3
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer1.org3.ibcn.unl.edu.ec/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGEID

#check the chaincode commit
 peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --output json

 #commit chaincode SUCCESS
 #Now commit chaincode. Note that we need to specify peerAddresses of both Org1 and Org3 (and their CA as TLS is enabled).
peer lifecycle chaincode commit -o orderer.ibcn.unl.edu.ec:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.org1.ibcn.unl.edu.ec:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/peers/peer0.org1.ibcn.unl.edu.ec/tls/ca.crt --peerAddresses peer1.org1.ibcn.unl.edu.ec:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/peers/peer1.org1.ibcn.unl.edu.ec/tls/ca.crt --peerAddresses peer0.org2.ibcn.unl.edu.ec:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt --peerAddresses peer1.org2.ibcn.unl.edu.ec:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer1.org2.ibcn.unl.edu.ec/tls/ca.crt --peerAddresses peer0.org3.ibcn.unl.edu.ec:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt --peerAddresses peer1.org3.ibcn.unl.edu.ec:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer1.org3.ibcn.unl.edu.ec/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"

echo "##########################################################"
echo "#             Chequear el estado del commit              #"
echo "##########################################################"

#check the status of chaincode commit
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --output json
