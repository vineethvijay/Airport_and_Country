#!/bin/bash

mv airport/run.war airports-assembly-1.0.1.jar
cp airport/airports-assembly-1.1.0.jar run.war

docker-compose -d restart

