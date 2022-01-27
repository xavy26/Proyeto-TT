# Primero se deben eliminar las carpetas que se crean al ejecutar los comandos

rm -R crypto-config
rm -R channel-artifacts

# Se debe crear el material criptografico, todos los certificados, componentes, llaves privadas. Para esto se nececita crytogen, se crea el archivo llamado crypto-config.yaml.

cryptogen generate --config=./crypto-config.yaml

# Este comando nos crea una carpeta llamada crypto-config, en la cual se encuentran dos carpetas, una con el material criptografico del orderer de la red y la segunda con el material criptografico de cada organización.
# Dentro del material criptografico se encuentra los certificados y llaves para CA, MSP, Orderers, TLS y Users. Estos certificados (x509) se pueden validar, estos se utilizan para identificar la identidad de quienes participan en la red.
# Si se desea validar estos certificados generados por crytogen, se lo puede hacer en el siguiente sitio https://www.dondominio.com/products/ssl/tools/ssl-checker/, donde se espeficará toda la información referente a este certificado.
# Los certificados contienen la indormacion de las llaves public, mientras que las llaves privadas se crean de forma autonoma.

# Luego de haber creado el material criptografico, se debe crear el bloque genesis, las transacciones de configuraciones, que son archivos de información nde como queda el canal, indormación de los anchorpeers. Todo esto se lo especifica en el archivo configtx.yaml.
# Configurado el archivo, se utiliza el comando configtxgen, se crea  el cloque genesis, el canal y los AnchorPeers de las organizaciones. Para almacenar las configuraciones se crea una carpeta denominada 'channel-artifacts'.El comando completo es el siguiente:

configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# Con ese comando se crea la configuración del bloque genesis, para la configuración del canal se modifica el comando anterior y queda como se muestra a continuación:

configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID evoting

# Para crear los archivos de configuración de los AnchorPeers, se lo hace de la misma forma, los comandos para cada organización quedarían como se muestra a continuación:

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID evoting -asOrg DTIMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID evoting -asOrg OCSMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID evoting -asOrg TEGMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org4MSPanchors.tx -channelID evoting -asOrg FARNRMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org5MSPanchors.tx -channelID evoting -asOrg FEIRNNRMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org6MSPanchors.tx -channelID evoting -asOrg FEACMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org7MSPanchors.tx -channelID evoting -asOrg FJSAMSP

configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org8MSPanchors.tx -channelID evoting -asOrg FSHMSP

# A continuación, para el despliegue, se utiliza la herramienta denominada Portainer para administrar las imagenes docker, para ello se crea un volumen para la herramienta y se crea y ejecuta el contenedor para la herramienta, esto se lo hace con los siguientes comandos:

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Antes de iniciar con el despliegue de la red, se crea variables las cueles facilitaran el despliegue de la red blockchain. Las variables son las siguientes:

export CHANNEL_NAME=evoting #Define el nombre del canal
export VERBOSE=false #Define el estado del VERBOSE
export FABRIC_CFG_PATH=$PWD #Define el directorio de las configuraciones de Fabric

# Siguendo con el despliegue de la red, se levanta el contenedor de CouchDB, para ello se utiliza el siguiente comando:

CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

# Luego se procede a configurar el canal, para ello se conecta a la consola de commandos del contenedor cli, una vez ahí, se utiliza el archivo channel.tx, primeramente se asigan el nombre del canal a una variable y se crea el bloque del canal, esto se lo reala¿iza con los siguientes comandos:

export CHANNEL_NAME=evoting

peer channel create -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

# Para añadir las organizaciones sea parte del canal, se lo realiza con el siguiente comando:

peer channel join -b evoting.block

# Con este comando, la primera organización se añade al canal creado, para añadir los otros canales se debe especificar la identidad de cada una de las organizaciones, como se muestra en el siguiente comando:

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/users/Admin@org1.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org1.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.ibcn.unl.edu.ec/peers/peer0.org1.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer1.org2.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer1.org3.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer0.org4.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer1.org4.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer0.org5.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer1.org5.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer0.org6.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer1.org6.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer0.org7.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer1.org7.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer0.org8.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer1.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer1.org8.ibcn.unl.edu.ec/tls/ca.crt peer channel join -b evoting.block

# Ahora se va a utilizar lso archivos de configuración de los AnchorPeers de las organizaicones para configurarlos en el canal

peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/users/Admin@org3.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org3.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.ibcn.unl.edu.ec/peers/peer0.org3.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org3MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/users/Admin@org4.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org4.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.ibcn.unl.edu.ec/peers/peer0.org4.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org4MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/users/Admin@org5.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org5.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org5MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.ibcn.unl.edu.ec/peers/peer0.org5.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org5MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/users/Admin@org6.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org6.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org6MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org6.ibcn.unl.edu.ec/peers/peer0.org6.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org6MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/users/Admin@org7.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org7.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org7MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org7.ibcn.unl.edu.ec/peers/peer0.org7.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org7MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/users/Admin@org8.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org8.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org8MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org8.ibcn.unl.edu.ec/peers/peer0.org8.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org8MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
