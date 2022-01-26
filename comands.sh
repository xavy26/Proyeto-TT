# Primero se debe crear el material criptografico, todos los certificados, componentes, llaves privadas. Para esto se nececita crytogen, se crea el archivo llamado crypto-config.yaml.

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

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.acme.com/users/Admin\@org3.acme.com/msp CORE_PEER_ADDRESS=peer0.org3.acme.com:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hy

perledger/fabric/peer/crypto/peerOrganizations/org3.acme.com/peers/peer0.org3.acme.com/tls/ca.crt peer channel join -b marketplace.block

# A continuación, para el despliegue, se utiliza una herramienta denominada Portainer para administrar las imagenes docker, para ello se crea un volumen para la herramienta y se crea y ejecuta el contenedor para la herramienta, esto se lo hace con los siguientes comandos:

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Antes de iniciar con el despliegue de la red, se crea variables las cueles facilitaran el despliegue de la red blockchain. Las variables son las siguientes:

export CHANNEL_NAME=evoting #Define el nombre del canal
export VERBOSE=false #Define el estado del VERBOSE
export FABRIC_CFG_PATH=$PWD #Define el directorio de las configuraciones de Fabric

# Siguendo con el despliegue de la red, se levanta el contenedor de CouchDB, para ello se utiliza el siguiente comando:

CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

# Luego se procede a configurar el canal, para ello se conecta a la consola de commandos del contenedor cli, una vez ahí se procede a 
