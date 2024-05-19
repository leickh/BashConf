#!/usr/bin/env bash

if [[ $# != 1 ]];
then
    echo "[INI-Parser] >> Usage: $0 <ini-file>" 1>&2
    exit -1
fi

function is_line_new_section() {
    LINE=$1
    FIRST_LETTER=$(echo $LINE | cut -c 1)
    if [[ $FIRST_LETTER == "[" ]];
    then
        echo "true"
        return
    fi
    echo "false"
}

function extract_section_name() {
    LINE=$1
    LEN_LINE=${#LINE}

    # Find the closing square bracket
    INDEX=1
    while [[ $INDEX -le $LEN_LINE ]];
    do
        CHARACTER=$(echo $LINE | cut -c $INDEX)
        if [[ $CHARACTER == ']' ]];
        then
            let INDEX=$INDEX-1
            echo $LINE | cut -c 2-$INDEX
            return
        fi
        let INDEX=$INDEX+1
    done
}

for LINE in $(cat $1)
do
    if [[ $(is_line_new_section $LINE) == "false" ]];
    then
        continue
    fi
    extract_section_name $LINE
done
