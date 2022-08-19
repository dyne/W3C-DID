#!/usr/bin/env bash

if [[ ! -d restroom ]]; then
    echo "restroom not found"
    echo "Use the command ./create.sh to import it"
    exit 1
fi

if [[ ! -f contracts/keyring.json ]]; then
    echo "keyring not found"
    echo "Use the command ./announce.sh to create it"
    exit 1
fi

cd restroom
pm2 start yarn --name did --time -- start
