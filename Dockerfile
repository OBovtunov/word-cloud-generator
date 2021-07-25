FROM golang:1.13.15
RUN apt-get update && apt-get install -y jq docker.io docker-compose

