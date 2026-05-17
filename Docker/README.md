backup $JENKINS_HOME dir
## Docker 
### pass param to Dockerfile
docker build --build-arg version=1.2 .

## how containers communicate
## by joining same custom bridge network
docker network create roboshop
docker run -d --network roboshop --name mongo mongo
docker run -d --network roboshop --name app roboshop/app

docker network inspect

docker-compose up -d
docker-compose down
docker-compose ps
docker-compose logs

docker volume create data_volume
docker run -v data_volume:/var/lib/mysql mysql

## bind mounts
map host dir into container --> docker run -v $(pwd):/app node

## optimize Docker layers
RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

## debug a running container 
docker exec -it bash

## logs
docker logs -f

## resource usage
docker stats

## rm all containers & images
docker rm -f $(docker ps -aq) docker rmi -f $(docker images -q)

## pass env vars while running containers
docker run-e DB_HOST=localhost -e DB_USER=root myapp

### connect to host network
docker run --network host nginx

## check container IP addr
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name

## push images to hub
docker login
docker tag myapp ecom/myapp:v1
docker push ecom/myapp:v1

## dangling images
docker image prune

## check image layers
docker history

## commit --> to create new image from running container's state
docker commit <container> myimage:v2

## inspect env vars inside container
docker exec env

## link two containers manually
docker run --link :alias_name

## latest code changes are not reflected, why
rebuild with --no-cache

OR modify COPY/RUN order to force cache refresh

### builds faster in CICD
COPY package.json before COPY .

netstat -tuln
EXPOSE 
docker ps
docker logs container_name

## two containers (frontend & backend) need to communicate
create user-defined bridge network & run both containers inside it
docker network create roboshop 
docker run -d --name backend --network roboshop mybackend 
docker run -d --name frontend --network roboshop myfrontend

## multi envs
use multi-compose files
docker-compose -f docker-compose.yml docker-compose.prod.yml up -d

OR use envs + .env file to override configs

## need to share data between containers
volumes:
    db_data
services: mysql
image: mysql
volumes: 
    - db_data:/var/lib/mysql app
    image: myapp
    depends_on: 
        - mysql

## debug container that immediately exits after starting
docker logs 
docker inspect | grep -i exitcode
docker run -it --entrypoint bash myimage

## high cpu usage inside a container
docker stats 
docker top
docker exec -it top 
docker run --cpus=1 --memory=512m

## use host system's network
docker run --network host prometheus

## two containers on diff network needs to communicate
Attach containers to both network
docker network connect netA container1
docker network connect netB container1

## need to rollback faulty images
use version tags
docker tag myapp:stable myapp:rollback
docker run myapp:rollback

## optimize pull time in Jenkins
use local docker registry cache
compress layers via BuildKit
docker buildx
reuse cached layers across agents

## can't delete image even after stopping container
docker ps -a --filter ancestor=

## disk usages very high on server due to docker
docker system prune -a 
docker volume prune

## process is consuming port inside container
docker exec -it netstat -tuln

## multi-arch/platforms build
docker  buildx build --platform linux/arm64,linux/amd64 -t myapp:multi .

## logs in prod
use docker logs driver(json, syslog, fluentd)
OR ship logs via promtail --> Loki, filebeat --> ELK

## across envs
tag & push images by version
docker tag myapp:v1 acr.azure.com/myapp:v1
docker push acr.azure.com/myapp:v1

## huge memory, how do you limit it
docker run --memory="500m" --cpus="1" myapp
verify --> docker inspect | grep -i memory

## run
docker run = pull + create + start

## list containers & images
docker ps 
docker ps -a
docker images

## remove all stopped
docker rm $(docker ps -aq)
docker rmi $(docker images -aq)
## OR safely prune
docker system prune -a ## unused stuffs

## access from internet
## publish ports from host --> container
docker run -d -p host_port:container_port nginx
docker run-d -p 80:80 nginx

## shell access 
docker exec -it container_name bash
docker exec -it container_name sh

## inspect details/logs
docker inspect 
docker logs -f
Dockerfile

## why doesn't systemctl work
use nginx -g 'daemon off;'

## LABEL = metadata
LABEL maintainer="ex@company.com" org="Team" version="1.0.0"

## ENTRYPOINT VS CMD
ENTRYPOINT ["ping"] CMD ["-c", "5","google.com"] 
defautl args; can override 'google.com' at runtime

## why run as non-root user
RUN adduser -D appuser USER appuser

## ARG VS ENV & using ARG before FROM
ARG BASE= alpine FROM nginx:1.25-${BASE}
docker build --build-agr BASE=alpine .

## ONBUILD = trigger steps in child images

## push to hub/ecr/nexus/jfrog
docker login
docker tag app:1.0 docker.io/joindevops/app:1.0
docker push docker.io/joindevops/app:1.0
## nexus/ecr/acr similar, just change the registry url

## talk to each other by name
same default bridge
docker network create expense
docker run -d --name mysql --network expense mysql:8
docker run -d --name backend --network expense backend:latest
docker run -d --name frontend --network expense -p 8080:80 frontend:latest

## find IP
docekr inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container

## Bind mounts vs named vol
eg. serve custom static site with nginx
docker run -d -p 80:80 \
    -v /home/ec2-user/nginx-data:/usr/share/nginx/html \
    --name web nginx

## app not reachable 404 file not found
docker logs
docker exec -it ls -R /usr/share/nginx/html
copied build output react/angular build/ or dist/ to nginx html
confirm port map -p 80:80 & cloud firewall rules

## exits immediate after start
docker run -it --entrypoint sh
check CMD/ENTRYPOINT correct

## high cpu/memory
docker stats
docker top 
docker run --cpus=1 --memory=512m app

## arch
CLI --> REST API --> docker daemon --> containerd --> runc --> namespaces + cgroups

## docker BuildKit
enable:
export DOCKER_BUILDKIT=1
docker build .
## advance 
# syntax=docker/dockerfile:1.4
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret

## container logs
json-file logging driver
you can change to 
syslog
fluentd
awslogs
gelf
none
docker run --log-driver=fluentd myapp
for prod --> forward to ELK, Loki or datadog

## healthcheck
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
CMD curl -f http://localhost:8080/health || exit 1
## view health
docker ps
## shows STATUS as healthy/unhealthy

## in docker-compose
healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:8080/health"] 
    interval:30s 
    timeout:5s 
    retries:3 

## best practices for prod secure
--cap-drop all & add only required capabilities
docker run --read-only --cap-drop ALL myapp

## multi compose file
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
## OR use .env file and refer in compose
ENV=prod
DB_USER=root
DB_PASS=secret

## context
docker context create pod --docker "host=ssh://ubuntu@prod-server"
docker context use prod
docker ps works on remote server -- no SSH required

## docker swarm
docker swarm init
docker service create --replicas 3 -p 80:80 nginx

## control remotely
exposes REST API usually at /var/run/docker.sock
export DOCKER_HOST=tcp://IP:2375

## system cmds
docker system df = disk usages
docker system prune -a 
docker stats = resource usage
docker events

## debug networking
# run diagnostic container
docker run -it network network_name nicolaka/netshoot ## netshoot includes dig, curl, tcpdump,etc for debug
## inside test DNS & ports
ping mysql
curl backend:8080

## metrics & monitoring(prod)
docker stats
for central
cAdvisor --> exposes container metrics
prometheus + grafana -- > visualize usage
datadog/newrelic/sysdig --> full observability






