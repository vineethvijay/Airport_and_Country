# Devops_Assignment

# Running 2 isolated microservices behind loadbalancer using Docker


[ Note : System Used : macOS High Sierra ]

Intial stack startup:

```docker-compose up --build ```

To run In background,

```docker-compose up -d --build ```

## What you need

1. Running docker service,

[Docker Running](../master/sample-images/docker-runnin.png)

<!---![alt text](https://github.com/vineethvijay/Devops_Assignment/blob/master/sample-images/docker-runnin.png )--->

2. Docker Version,

[Docker Version](../master/sample-images/docker-version.png)


## Running the code,

```
vineeth:Devops_Assignment vineeth_vijay$ docker-compose up --build
Creating network "devops_assignment_default" with the default driver
Building countries
Step 1/5 : FROM openjdk:8u171-jdk-stretch
 ---> a2fbe0dde8c0
Step 2/5 : MAINTAINER Vineeth "vineethvijay777@gmail.com"
 ---> Using cache
 ---> 9b48014cc5db
Step 3/5 : WORKDIR /code
 ---> Using cache
 ---> 744038f9859b
Step 4/5 : EXPOSE 8080
 ---> Using cache
 ---> 5dc2d818fb49
Step 5/5 : ENTRYPOINT java -jar /code/run.jar
 ---> Using cache
 ---> 26b3f82b4de1
Successfully built 26b3f82b4de1
Successfully tagged devops_assignment_countries:latest
Building airports
Step 1/4 : FROM openjdk:8u171-jdk-stretch
 ---> a2fbe0dde8c0
Step 2/4 : MAINTAINER Vineeth "vineethvijay777@gmail.com"
 ---> Using cache
 ---> 9b48014cc5db
Step 3/4 : WORKDIR /code
 ---> Using cache
 ---> 744038f9859b
Step 4/4 : ENTRYPOINT java -jar /code/run.jar
 ---> Using cache
 ---> 7a780da99325
Successfully built 7a780da99325
Successfully tagged devops_assignment_airports:latest
Building nginx
Step 1/2 : FROM nginx:alpine
 ---> bc7fdec94612
Step 2/2 : ADD nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> 9e4e89af8e4f
Successfully built 9e4e89af8e4f
Successfully tagged devops_assignment_nginx:latest
Creating devops_assignment_airports_1  ... done
Creating devops_assignment_countries_1 ... done
Creating devops_assignment_nginx_1     ... done
Attaching to devops_assignment_countries_1, devops_assignment_airports_1, devops_assignment_nginx_1
countries_1  | [info] play.api.Play - Application started (Prod)
airports_1   | [info] play.api.Play - Application started (Prod)
countries_1  | [info] p.c.s.AkkaHttpServer - Listening for HTTP on /0.0.0.0:8080
airports_1   | [info] p.c.s.AkkaHttpServer - Listening for HTTP on /0.0.0.0:8080
countries_1  | [info] application - Start loading Countries

```

## Testing results,

http://localhost:8000/<endpoints>


### Cleanup incase containers exits with leaving RUNNING_PID

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




