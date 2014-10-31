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

echo "${shardAmounts}"

mkdir logs

for (( c=1; c<=shardAmounts; c++ ))
do
    echo "... creatinng Shard ${c}"
    mkdir shard$c
    mongod --dbpath shard$c --port 3000$c --fork --smallfiles --logpath logs/shard$c.log --logappend --oplogSize 10 --shardsvr #--replSet <setname>
done

#mongod --configsvr --dbpath /data/configdb --port 27019
