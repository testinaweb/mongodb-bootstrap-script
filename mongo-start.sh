#!/bin/bash

echo "##### SCRIPT FOR SHARD CREATION #####"

read -p "Declare a name? [shard] : " shardName
if [ "${shardName}" == "" ]; then
    shardName='shard'
fi

read -p "How many shards you need? [3] : " shardAmounts
if [ "${shardAmounts}" == "" ]; then
    shardAmounts=3
fi

read -p "How many config servers you need? [1] : " configsvrAmounts
if [ "${configsvrAmounts}" == "" ]; then
    configsvrAmounts=1
fi


echo "Start creation..."

mkdir logs

# shardsvr
for (( c=1; c<=$shardAmounts; c++ ))
do
    echo "... creatinng shard ${c}"
    mkdir shard$c
    mongod --dbpath shard$c --port 3000$c --fork --smallfiles --logpath logs/shard$c.log --logappend --oplogSize 10 --shardsvr #--replSet <setname>
done

# configsvr
for (( c=1; c<=$configsvrAmounts; c++ ))
do
    echo "... creatinng config server ${c}"
    mkdir configsvr$c
    mongod --dbpath configsvr$c --port 2702$c --fork --smallfiles --logpath logs/configsvr$c.log --logappend --oplogSize 10 --configsvr
done

mongos --configdb localhost:27021
#sh.addShard("rs1/mongodb0.example.net:27017")
