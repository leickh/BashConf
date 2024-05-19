#!/usr/bin/env bash

SCRIPT_PATH=$(dirname $0)

if [[ $# != 2 ]];
then
    echo "[INI-Parser] >> Usage: $0 <file-path> <section.field>" 1>&2
    exit -1
fi

INI_PATH=$1
REQUEST=$2

STATEMENT=$(bash $SCRIPT_PATH/print-statement.bash $INI_PATH $REQUEST)
if [[ $STATEMENT == "" ]];
then
    echo "[INI-Parser] >> Field for $REQUEST not found."
    exit -1
fi
LEN_STATEMENT=${#STATEMENT}

INDEX=1
while [[ $INDEX -le $LEN_STATEMENT ]];
do
    CHARACTER=$(echo $STATEMENT | cut -c $INDEX)
    if [[ $CHARACTER == '=' ]];
    then
        let INDEX=$INDEX+1
        echo $STATEMENT | cut -c $INDEX-
        break
    fi
    let INDEX=$INDEX+1
done
