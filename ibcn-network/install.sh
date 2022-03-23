#!/bin/bash

# Primero se deben eliminar las carpetas que se crean al ejecutar los comandos
sudo rm -R crypto-config
sudo rm -R channel-artifacts

# Material criptografico
echo "####################################################### "
echo "#Material criptografico# "
echo "####################################################### "
cryptogen generate --config=./crypto-config.yaml

# Bloque genesis, el canal y los AnchorPeers
echo "####################################################### "
echo "#Bloque genesis, el canal y los AnchorPeers# "
echo "####################################################### "
mkdir channel-artifacts
configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# Configuración del canal 
echo "####################################################### "
echo "#Configuración del canal# "
echo "####################################################### "
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID evoting

# Crear los archivos de configuración de los AnchorPeers
echo "####################################################### "
echo "#Archivos de configuración de los AnchorPeers# "
echo "####################################################### "
# AnchorPeer Org1
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID evoting -asOrg DTIMSP
# AnchorPeer Org2
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID evoting -asOrg OCSMSP
# AnchorPeer Org3
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID evoting -asOrg TEGMSP
# AnchorPeer Org4
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org4MSPanchors.tx -channelID evoting -asOrg FARNRMSP
# AnchorPeer Org5
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org5MSPanchors.tx -channelID evoting -asOrg FEIRNNRMSP
# AnchorPeer Org6
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org6MSPanchors.tx -channelID evoting -asOrg FEACMSP
# AnchorPeer Org7
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org7MSPanchors.tx -channelID evoting -asOrg FJSAMSP
# AnchorPeer Org8
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org8MSPanchors.tx -channelID evoting -asOrg FSHMSP

# Contenedor Portainer
echo "####################################################### "
echo "#Contenedor Portainer# "
echo "####################################################### "
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Crea variables
echo "####################################################### "
echo "#Crear variables# "
echo "####################################################### "
export CHANNEL_NAME=evoting #Define el nombre del canal
export VERBOSE=false #Define el estado del VERBOSE
export FABRIC_CFG_PATH=$PWD #Define el directorio de las configuraciones de Fabric
echo $CHANNEL_NAME
echo $VERBOSE
echo $FABRIC_CFG_PATH
# Siguendo con el despliegue de la red, se levanta el contenedor de CouchDB, para ello se utiliza el siguiente comando:
echo "####################################################### "
echo "#Crear contenedores de Peers y CouchDB# "
echo "####################################################### "
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

docker cp confChannel.sh cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/confChannel.sh
docker container exec -it cli ls
docker container exec -it cli chmod +x confChannel.sh
docker container exec -it cli ./confChannel.sh

echo "####################################################### "
echo "#              INSTALAR CHAINCODE                     # "
echo "####################################################### "
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-
docker cp chaincode/evoting/ cli:/opt/gopath/src/github.com/chaincode/evoting/
docker cp chaincode/installChaincode.sh cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/installChaincode.sh
docker container exec -it cli ls
docker container exec -it cli chmod +x instainstallChaincodell.sh
docker container exec -it cli ./installChaincode.sh