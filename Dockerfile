FROM golang:1.13.15
RUN apt-get update && apt-get install -y docker.io docker-compose

# && apt-get install -y build-essential && apt-get install -y jq openjdk-11-jdk && apt-get
