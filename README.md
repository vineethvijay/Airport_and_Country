# Devops_Assignment 


### Running 2 isolated microservices behind loadbalancer using Docker
## with failover deployment to airport service version2

[ System Used : macOS High Sierra ]

## Intial stack startup:

```docker-compose up --build ```

To run In background,

```docker-compose up -d --build ```

then view logs using ```docker-compose logs --follow```

## What you need

1. Running docker service,

[Docker Running](../master/sample-images/docker-runnin.png)

<!---![alt text](https://github.com/vineethvijay/Devops_Assignment/blob/master/sample-images/docker-runnin.png )--->

2. Docker Version,

[Docker Version](../master/sample-images/docker-version.png)


## Config and Dockerfiles

Countries Service :

```
FROM openjdk:8u171-jdk-stretch

WORKDIR /code

ENTRYPOINT java -jar /code/run.jar

```

Airports Service :

```
FROM openjdk:8u171-jdk-stretch

WORKDIR /code

ENTRYPOINT java -jar /code/run.jar
```

Nginx Reverse Proxy :

```
FROM nginx:alpine

ADD nginx.conf /etc/nginx/nginx.conf
```


nginx.conf :

```


worker_processes 1;

events { worker_connections 512; }

http {

    sendfile on;

    server {
        listen 80;

        location /countries {
            return 503 "503";
        }

        location /airports {
            return 503 "503 ";
        }

    }

    upstream countries-server {
        server countries:8080 fail_timeout=1s;
        server nginx:80 backup;
    }


    upstream airports-server {
        server airports1:8080 backup;
        server airports2:8080 backup;
        #server nginx:80 backup;
    }


    server {
        listen 8000;

        location /countries {

            proxy_pass         http://countries-server;
            proxy_redirect     off;
            proxy_set_header   Host $host;
        }


        location /countries/health/live {
            return 200 "200";
        }

        location /countries/health/ready {
            proxy_pass         http://countries-server/countries;
            proxy_redirect     off;
            proxy_read_timeout   1s;

        }


        location /airports {

            proxy_pass         http://airports-server;
            proxy_redirect     off;
            proxy_set_header   Host $host;

        }

        location /airports/health/live {
            return 200 "200";
        }

        location /airports/health/ready {
            proxy_pass         http://airports-server/airports;
            proxy_redirect     off;
            proxy_read_timeout   2s;

        }

    }

}


```

Notes :


```
    upstream countries-server {
        server countries:8080 fail_timeout=1s;
        server nginx:80 backup;
    }

```


Here the upstream server for both services is distributed to application service endpoint and also to an nginx 80 port with `fail_timeouts` and `backup` directives,  which is used to get the `health/ready` of the service.

 
[Nginx upstream Doc](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)

## Whole stack as code - docker-compose

```
version: '3'
services:

  nginx:
    build: nginx
    #command: "echo 'Running nginx reverse proxy.. Service up.. Listening on 0.0.0.0:8000'"
    ports:
      - "8000:8000"
    links:
      - countries
      - airports1
      - airports2
    
  countries:
    build: countries
    volumes:
     - ./countries:/code

  airports1:
    build: airport1
    volumes:
      - ./airport1:/code

  airports2:
    build: airport2
    volumes:
      - ./airport2:/code

```

## Running the code,

```
vineeth:Devops_Assignment vineeth_vijay$ docker-compose up --build
Creating network "devops_assignment_default" with the default driver
Building countries
Step 1/4 : FROM openjdk:8u171-jdk-stretch
 ---> a2fbe0dde8c0
Step 2/4 : WORKDIR /code
 ---> Using cache
 ---> 329ba58f213c
Step 3/4 : EXPOSE 8080
 ---> Using cache
 ---> f2ba95aadff7
Step 4/4 : ENTRYPOINT java -jar /code/run.jar
 ---> Using cache
 ---> 1b42a1a415f6
Successfully built 1b42a1a415f6
Successfully tagged devops_assignment_countries:latest
Building airports1
Step 1/3 : FROM openjdk:8u171-jdk-stretch
 ---> a2fbe0dde8c0
Step 2/3 : WORKDIR /code
 ---> Using cache
 ---> 329ba58f213c
Step 3/3 : ENTRYPOINT java -jar /code/run.jar
 ---> Using cache
 ---> 0f0cfc036145
Successfully built 0f0cfc036145
Successfully tagged devops_assignment_airports1:latest
Building airports2
Step 1/3 : FROM openjdk:8u171-jdk-stretch
 ---> a2fbe0dde8c0
Step 2/3 : WORKDIR /code
 ---> Using cache
 ---> 329ba58f213c
Step 3/3 : ENTRYPOINT java -jar /code/run.jar
 ---> Using cache
 ---> 0f0cfc036145
Successfully built 0f0cfc036145
Successfully tagged devops_assignment_airports2:latest
Building nginx
Step 1/2 : FROM nginx:alpine
 ---> bc7fdec94612
Step 2/2 : ADD nginx.conf /etc/nginx/nginx.conf
 ---> b7bcf43d760d
Successfully built b7bcf43d760d
Successfully tagged devops_assignment_nginx:latest
Creating devops_assignment_airports1_1 ... done
Creating devops_assignment_airports2_1 ... done
Creating devops_assignment_countries_1 ... done
Creating devops_assignment_nginx_1     ... done
Attaching to devops_assignment_airports2_1, devops_assignment_airports1_1, devops_assignment_countries_1, devops_assignment_nginx_1
airports2_1  | [info] play.api.Play - Application started (Prod)
airports1_1  | [info] play.api.Play - Application started (Prod)
countries_1  | [info] play.api.Play - Application started (Prod)
airports2_1  | [info] p.c.s.AkkaHttpServer - Listening for HTTP on /0.0.0.0:8080
airports1_1  | [info] p.c.s.AkkaHttpServer - Listening for HTTP on /0.0.0.0:8080
countries_1  | [info] p.c.s.AkkaHttpServer - Listening for HTTP on /0.0.0.0:8080

```

# Testing results,

## Countries

To check countries service HTTP server is up,

http://localhost:8000/countries/health/live

To check countries service is ready,

http://localhost:8000/countries/health/ready

[http response status returned "503" - when initializing, 200 when service up ]


To search for countries services,

http://localhost:8000/countries


To search for countries services - country by name / ISO code.

http://localhost:8000/countries/<code>

eg: http://localhost:8000/countries/AD


## Airports

To check airports service HTTP server is up,

http://localhost:8000/airports/health/live

To check airports service is ready,

http://localhost:8000/airports/health/ready

[http response status returned "503" - when initializing, 200 when service up ]


To search for airports services,

http://localhost:8000/airports


To search for airports services -  by name / ISO code.

http://localhost:8000/airports/<code>

eg: http://localhost:8000/airports/NL


## Fail-over deploy to airport version-2

1. Verify current deployed version is 1,
http://localhost:8000/airports/EHAM --> returns []

2. Deploy version-2 to airports2 container,
`./deploy-airport-v2.sh airports2`

3. Verify version1 is still up while deployment is progessing,
http://localhost:8000/airports/NL

4. Follow logs in another shell to see the deployment is successfull,
`docker-compose logs --follow`

5. Verify version-2 is coming sending a batch of requests(deponds on `max_fails` directive(set as 2) ,
http://localhost:8000/airports/EHAM --> returns version2 json output

6. Deploy version-2 to airports1 container,
`./deploy-airport-v2.sh airports1`

7. Follow logs in another shell to see the deployment is successfull,
`docker-compose logs --follow`

8. Verify version-2 is coming in successful,
http://localhost:8000/airports/EHAM --> returns version2 json output


## Deploy script

```
#!/bin/bash

deploy_to_container=$1

if [ -n "$1" ]
then
  echo -e "\nDeploying version-2 to $deploy_to_container "
else
  echo -e "Script needs deploy_to_container name - (airports1 / airports2) \n..Exiting..\n"
  exit
fi

if [ $deploy_to_container == "airports2" ]
then
	docker-compose stop airports2
	cp -f deploy/airports-assembly-1.1.0.jar airport2/run.jar
	rm airport2/RUNNING_PID
	docker-compose start airports2
elif [ $deploy_to_container == "airports1" ]
then
	docker-compose stop airports1
	cp -f deploy/airports-assembly-1.1.0.jar airport1/run.jar
	rm airport1/RUNNING_PID
	docker-compose start airports1
else
	echo "No matching container name"

fi
```


## Cleanup incase containers exits with leaving RUNNING_PID

```bash clean.sh```

Script :
```
#!/bin/bash 
docker-compose down 
rm countries/RUNNING_PID 
rm airport/RUNNING_PID 
```

Running snippet :

```
vineeth:Devops_Assignment vineeth_vijay$ ./clean.sh
Stopping devops_assignment_nginx_1 ... done
Removing devops_assignment_nginx_1     ... done
Removing devops_assignment_countries_1 ... done
Removing devops_assignment_airports_1  ... done
Removing network devops_assignment_default
```




