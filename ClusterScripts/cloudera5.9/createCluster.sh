#!/bin/bash
# This script creates a cluster on Docker based on Cloudera CDH 5.9
# Based on Loicmathieu's work 
# More informations available at https://github.com/loicmathieu/docker-cdh/tree/master/cloudera-cdh-edgenode

echo "This script creates a cluster on Docker based on Cloudera CDH"
echo "Based on Loicmathieu's work"
echo "More informations available at https://github.com/loicmathieu/docker-cdh/tree/master/cloudera-cdh-edgenode"

network="hadoop"
read -p "Please insert the network name ($network by default): " -e network
[ -z "${network}" ] && network="hadoop"

numberNodes=3
read -p "Please insert the number of datanode ($numberNodes by default): " -e numberNodes
[ -z "${numberNodes}" ] && numberNodes=3


echo "Creating a Cloudera CHD 5.9 cluster on network $network with $numberNodes datanode(s)"

# Pull Docker Images
echo "Download Docker images"
docker pull loicmathieu/cloudera-cdh-namenode
docker pull loicmathieu/cloudera-cdh-yarnmaster
docker pull loicmathieu/cloudera-cdh-datanode
docker pull loicmathieu/cloudera-cdh-edgenode

## Create a Docker Bridged Network
echo "Create a Docker Bridged Network"
docker network create "$network"

## Create Yarnmaster
echo "Creating Yarn Node"
docker run -d --net "$network" --net-alias yarnmaster --name yarnmaster -h yarnmaster -p 8032:8032 -p 8088:8088 -p 8080:8080 -p 19888:19888 loicmathieu/cloudera-cdh-yarnmaster

## Create Namenode
echo "Creating NameNode"
docker run -d --net "$network" --net-alias namenode --name namenode -h namenode -p 8020:8020 loicmathieu/cloudera-cdh-namenode

echo "Creating DataNodes"
for i in `seq 1 $numberNodes`;
do	
    echo "Creating DataNode $i"
    port1=$(( 8042 + $i ))
    port2=$(( 50020 + $i ))
    port3=$(( 50075 + $i ))
    docker run -d --net "$network" --net-alias "datanode$i"  -h "datanode$i" --name "datanode$i" --link namenode --link yarnmaster -p "$port1:8042" -p "$port2:50020" -p "$port3:50075" loicmathieu/cloudera-cdh-datanode
done

echo "Creating Edge Node"
docker run -ti --net "$network" --net-alias edgenode --name edgenode --link namenode --link yarnmaster loicmathieu/cloudera-cdh-edgenode bash

