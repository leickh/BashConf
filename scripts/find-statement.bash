#!/usr/bin/env bash

INVOCATION_PATH=$(dirname $0)

if [[ $# != 2 ]];
then
    echo "[INI-Parser] >> Usage: $0 <file-path> <section.field>" 1>&2
    exit -1
fi

INI_PATH=$1
REQUEST=$2

# Split request into  (if there is one) a category-name and the field-name

LEN_FIELD=${#REQUEST}
INDEX=1
SPLITTER_INDEX=0
while [[ $INDEX -le $LEN_FIELD ]]
do
    CHARACTER=$(echo $REQUEST | cut -c $INDEX)
    if [[ $CHARACTER == "." ]];
    then
        SPLITTER_INDEX=$INDEX
        break
    fi
    let INDEX=$INDEX+1
done

if [[ $SPLITTER_INDEX > 1 ]];
then
    let BEFORE_SPLITTER_INDEX=$SPLITTER_INDEX-1
    SECTION=$(echo $REQUEST | cut -c 1-$BEFORE_SPLITTER_INDEX)
fi
let SPLITTER_INDEX=$SPLITTER_INDEX+1
FIELD=$(echo $REQUEST | cut -c $SPLITTER_INDEX-)

if [[ $SECTION == "" ]];
then
    echo "[INI-Parser] >> A section as well as a field is needed!" 1>&2
    exit -1
fi

# Part Identification Section

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

function extract_field_name() {
    LINE=$1
    LEN_LINE=${#LINE}

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
        let INDEX=$INDEX+1
    done
}

# Loop through the file

SECTION_CONTENT=$(bash $INVOCATION_PATH/print-section.bash $INI_PATH $SECTION)
for LINE in $SECTION_CONTENT;
do
    if [[ $(is_line_new_section $LINE) == true ]];
    then
        break
    fi
    if [[ $(extract_field_name $LINE) == $FIELD ]];
    then
        echo $LINE
        break
    fi
done
