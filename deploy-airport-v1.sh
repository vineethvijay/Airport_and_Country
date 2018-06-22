#!/bin/bash

deploy_to_container=$1

if [ -n "$1" ]
then
  echo -e "\nDeploying version-1 to $deploy_to_container "
else
  echo -e "Script needs deploy_to_container name - (airports1 / airports2) \n..Exiting..\n"
  exit
fi

if [ $deploy_to_container == "airports2" ]
then
	docker-compose stop airports2
	cp -f deploy/airports-assembly-1.0.1.jar airport2/run.jar
	rm airport2/RUNNING_PID
	docker-compose start airports2
elif [ $deploy_to_container == "airports1" ]
then
	docker-compose stop airports1
	cp -f deploy/airports-assembly-1.0.1.jar airport1/run.jar
	rm airport1/RUNNING_PID
	docker-compose start airports1
else
	echo "No matching container name"

fi


