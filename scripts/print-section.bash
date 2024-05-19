#!/usr/bin/env bash

if [[ $# != 2 ]];
then
    echo "[INI-Parser] >> Usage: $0 <file-path> <section-name>" 1>&2
    exit -1
fi

INI_PATH=$1
SECTION=$2

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

CURRENT_LINE_INDEX=0
SECTION_FOUND="false"
while read LINE; do
    let CURRENT_LINE_INDEX=$CURRENT_LINE_INDEX+1
    if [[ $SECTION_FOUND == "false" ]];
    then
        if [[ $(is_line_new_section $LINE) == "false" ]];
        then
            continue
        fi
        if [[ $(extract_section_name $LINE) != $SECTION ]];
        then
            continue
        fi
        SECTION_FOUND="true"
        continue
    fi
    if [[ $LINE == "" ]];
    then
        continue
    fi
    if [[ $(is_line_new_section $LINE) == "true" ]];
    then
        break
    fi
    echo $LINE
done <$INI_PATH
