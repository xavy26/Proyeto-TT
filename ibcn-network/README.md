# Evoting Network

A continuación se muestra el proceso que se siguió para crear la red Blockchain evoting-network utilizando HyperLedger Fabric.

## Pre-requisitos

Antes de iniciar con las configuraciones necesarias, es necesario tener instalado las tecnologías que se van a utilizar en la creación de la red. Para ello se debe ejecutar el archivo ``prerequisitos.sh`` que se encuentra en la carpeta `scripts/`, para ejecutar se debe ingresar al directorio donde se encuentra el archivo y darle permisos de ejecución, esto se lo realiza con los siguientes comandos:

```bash
cd scripts/
sudo chmod +x prerequisitos.sh
./prerequisitos.sh
cd ..
```
## Creación de archivos

Una vez se tenga todos los pre-requisitos, se procede a crear los archivos que se necesitará para el despliegue de la red Blockchain.

### Material criptográfico

Para crear el material criptografico, certificados, componentes, llaves públicas y privados. Se utilizará el archivo `crypto-config.yaml` el cual se ejecutara haciendo uso de la librería `cryptogen` de HyperLedger Fabric, tal como se muestra a continuación:

```bash
cryptogen generate --config=./crypto-config.yaml 
```
### Bloque génesis

Se debe crear el bloque genesis, los archivos de configuraciones, que son archivos de información de como queda el canal, información de los AnchorPeers. Todo esto se lo especifica en el archivo ``configtx.yaml``. Configurado el archivo, se utiliza el comando configtxgen, se crea  el bloque genesis, el canal y los AnchorPeers de las organizaciones. Para almacenar las configuraciones se crea una carpeta denominada ``channel-artifacts``. El comando completo es el siguiente:

```bash
mkdir channel-artifacts
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID evoting
```
### Canal

Luego de crear las configuraciones de gel bloque génesis, para crear la configuración del canal se modifica el comando anterior y queda como se muestra a continuación:

```bash
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID evoting
```
### AnchorPeers

Para crear los archivos de configuración de los AnchorPeers, se lo hace de la misma forma, los comandos para cada organización quedarían como se muestra a continuación:

```bash
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
```

## Creación de la red
### Portainer
Para el despliegue, se utiliza la herramienta denominada Portainer para administrar las imagenes docker, para ello se crea un volumen para la herramienta y se crea y ejecuta el contenedor para la herramienta, esto se lo hace con los siguientes comandos:

```bash
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```
Luego se debe configurar el usuario administrador para ello se ingresa a la dirección `http://localhost:9000/`.

### Ejecutar contenedores
Primero se crean variables las cueles facilitaran el despliegue de la red blockchain. Las variables son las siguientes:

```bash
export CHANNEL_NAME=evoting #Define el nombre del canal
export VERBOSE=false #Define el estado del VERBOSE
export FABRIC_CFG_PATH=$PWD #Define el directorio de las configuraciones de Fabric
```

Luego se levanta los contenedores de Cli, CA, Orderer, Peers y CouchDB, para ello se utiliza el siguiente comando:

```bash
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d
```

Se puede verificar la creación de los contenedores ingresando al Portainer y dirigiendoce al directorio de los contenedores.

## Creación del canal
Para crear el canal, se bebe ingresar a la consola del contenedor cli, que es donde se culminara con las configuraciones de la red, esto se lo puede hacer utilizando la herramienta Portainer.

Una vez dentro de la consola , se utiliza el archivo `channel.tx`, primeramente se asigna el nombre del canal a una variable y se crea el bloque del canal, esto se lo realiza con los siguientes comandos:

```bash
export CHANNEL_NAME=evoting
peer channel create -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
```

## Añadir organizaciones al canal

Para añadir el peer0 de la organización 1 al canal se lo realiza con el siguiente comando:

```bash
peer channel join -b evoting.block
```

Para añadir el peer1 de la Org1 y los peers de las organizaciones restantes, se debe añadir la identidad digital de cada peer, como se muestra en el siguiente comando:

```bash
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
```

## Configuración de AnchorPeers

Para esto se utiliza los archivos de configuración de los AnchorPeers de las organizaciones para configurar los en el canal, esto se lo hace solo con un peer de cada organización.

Para configurar el AnchorPeer de la primera organización se haciendo uso del siguiente comando:

```bash
peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
```

Como en el paso anterior, el comando para el peer0 de la Org2 en adelante, se debe añadir la identidad digital, como se muestra a continuación:

```bash
# Org2
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/users/Admin@org2.ibcn.unl.edu.ec/msp CORE_PEER_ADDRESS=peer0.org2.ibcn.unl.edu.ec:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.ibcn.unl.edu.ec/peers/peer0.org2.ibcn.unl.edu.ec/tls/ca.crt peer channel update -o orderer.ibcn.unl.edu.ec:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ibcn.unl.edu.ec/orderers/orderer.ibcn.unl.edu.ec/msp/tlscacerts/tlsca.ibcn.unl.edu.ec-cert.pem
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
```
Y con esto concluye la configuración de la red Blockain, es decir, la red se encuentra lista para realizar transacciones y ejecutar contratos inteligentes.