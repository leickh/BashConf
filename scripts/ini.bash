#!/usr/bin/env bash

SCRIPT_PATH=$(pwd)/$(dirname $0)

if [[ $# < 1 ]];
then
    echo "No action given! Try: $0 help" 1>&2
    exit -1
fi

case $1 in
    "ls" | "list-sections")
        if [[ $# != 2 ]];
        then
            echo "Action '$1' needs one argument: <ini_path>" 1>&2
            exit -1
        fi
        bash $SCRIPT_PATH/list-sections.bash "$2"
        exit 0
        ;;
    "lf" | "list-fields")
        if [[ $# != 3 ]];
        then
            echo "Action '$1' needs two aguments: <ini_path> and <section>" 1>&2
            exit -1
        fi
        bash $SCRIPT_PATH/list-fields.bash "$2" "$3"
        exit 0
        ;;
    "ps" | "print-section")
        if [[ $# != 3 ]];
        then
            echo "Action '$1' needs two arguments: <ini_path> and <section>" 1>&2
            exit -1
        fi
        bash $SCRIPT_PATH/print-section.bash "$2" "$3"
        exit 0
        ;;
    "vs" | "print-value")
        if [[ $# != 3 ]];
        then
            echo "Action '$1' needs two arguments: <ini_path> and <section.statement>" 1>&2
            exit -1
        fi
        bash $SCRIPT_PATH/print-value.bash "$2" "$3"
        exit 0
        ;;
    "h" | "help")
        echo "============[ Actions Start ]============"
        echo " "
        echo "|------------------------------------------------------>>"
        echo "| $0 [ ls | list-sections ]   <ini_path>"
        echo "|    List sections in file"
        echo "\\    at <ini_path>"
        echo " "
        echo "|------------------------------------------------------>>"
        echo "| $0 [ lf | list-fields ]     <ini_path>  <section>"
        echo "|    List fields of <section> in"
        echo "\\    file at <ini_path>"
        echo " "
        echo "|------------------------------------------------------>>"
        echo "| $0 [ ps | print-section ]   <ini_path>  <section>"
        echo "|    Print section content of file"
        echo "\\    at <ini_path>"
        echo " "
        echo "|------------------------------------------------------>>"
        echo "| $0 [ pv | print-value ]     <ini_path>  <section.statement>"
        echo "|    Print value at section/statement"
        echo "|    pair of <section.statement> in"
        echo "\\    file at <ini_path>"
        echo " "
        echo "=============[ Actions End ]============="
        ;;
    *)
        echo "Unknown action: '$1'! Try $0 help" 1>&2
        ;;
esac
