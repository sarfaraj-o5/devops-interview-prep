FROM node:18-alpine
WORKDIR /app
COPY ..
RUN npm install
EXPOSE 8080
CMD [ "node","server.js" ]

### multi-stage build

FROM golang:1.19 AS builder
WORKDIR /app
COPY ..
RUN go build -o main .

# Runtime stage
FROM alpine
WORKDIR /app
COPY --from=builder /app/main .
CMD [ "./main" ]

## build time is too high 
COPY package*.json ./
RUN npm ci
COPY ..

## build fails "Permission denied"
USER root
RUN apt-get install -y curl
USER appuser

## need to run script before main process starts
## use entrypoint + cmd combo

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "python","app.py" ]

## app requires creds during build how to secure
## use build agrs(not env vars)
ARG TOKEN
RUN git clone https://token@github.com/repo.git
## then
## docker build --build-arg TOKEN=$GIT_TOKEN

#### compact, prod-grade, nginx build
FROM nginx:1.25-alpine
# Remove default size & add your content
RUN rm -rf /usr/share/nginx/html/*
COPY ./public/ /usr/share/nginx/html/
EXPOSE 80
CMD [ "nginx","-g","daemon off;" ]

## multi-stage
FROM golang:1.22 AS build
WORKDIR /src 
COPY ..
RUN go build -o app

FROM alpine:3.20
WORKDIR /app
COPY --from=build /src/app .
USER 10001
CMD [ "./app" ]

## debug - multi-stage
FROM ubuntu:22.04 AS debug
RUN apt update && apt install -y curl vim
WORKDIR /app
COPY ..

## docker build -t debug --target debug .
## docker run -it debug bash

## caching best practice
FROM 
WORKDIR 
COPY requirement.txt / package.json
RUN pip install / npm ci
COPY .. 
CMD [ "executable" ]

