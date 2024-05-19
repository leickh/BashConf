#!/usr/bin/env bash

INVOCATION_PATH=$(dirname $0)

if [[ $# != 2 ]];
then
    echo "[INI-Parser] >> Usage: $0 <file-path> <section-name>" 1>&2
    exit -1
fi

INI_PATH=$1
SECTION=$2

WANTED_LINE_INDEX=$(bash $INVOCATION_PATH/print-section.bash $INI_PATH $SECTION)
if [[ $WANTED_LINE_INDEX == "" ]];
then
    exit 0
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

function extract_field_name() {
    LINE=$1
    LEN_LINE=${#LINE}

    # Find the equals sign OR the first whitespace
    INDEX=1
    while [[ $INDEX -le $LEN_LINE ]];
    do
        CHARACTER=$(echo $LINE | cut -c $INDEX)
        if [[ $CHARACTER == '=' ]];
        then
            let INDEX=$INDEX-1
            echo $LINE | cut -c 1-$INDEX
            return
        fi
        if [[ $CHARACTER == ' ' ]];
        then
            let INDEX=$INDEX-1
            echo $LINE | cut -c 1-$INDEX
            return
        fi
        let INDEX=$INDEX+1
    done
}

SECTION_CONTENT=$(bash $INVOCATION_PATH/print-section.bash $INI_PATH $SECTION)
for LINE in $SECTION_CONTENT;
do
    if [[ $(is_line_new_section $LINE) == true ]];
    then
        break
    fi
    extract_field_name $LINE
done
