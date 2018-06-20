#!/bin/bash


mv airport/run.jar airport/airports-assembly-1.0.1.jar
cp airport/airports-assembly-1.1.0.jar airport/run.jar
#bash clean.sh

docker-compose up --build

