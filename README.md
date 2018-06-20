# Devops_Assignment


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




## Testing results,

http://localhost:8000/<endpoints>


### Cleanup incase containers exits with leaving RUNNING_PID

```bash clean.sh```

```
#!/bin/bash 
docker-compose down 
rm countries/RUNNING_PID 
rm airport/RUNNING_PID 
```
