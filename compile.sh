#!/bin/bash
set -m # Enable Job Control


flagTest="false"

function complilingProjects() {
  line=$1;
  if [ -d "$line" ];then
    echo "*************** Compliling... : $line"
    cd $line
    mvn clean install -DskipTests=$flagTest
  else
    echo "No es un directorio $line"
    exit -1
  fi


}
###############################################################################

if [ -z $1 ]; then
  echo "The script need a parameter "
  exit -1
else
  if [ ! -f $1 ]; then
    echo "The file must exist "
    exit -2
  fi
fi

if [ ! -z  $2 ] ; then
  flagTest="true"
fi

while IFS='' read -r line || [[ -n "$line" ]]; do
  complilingProjects $line $flagTest
done < "$1"
