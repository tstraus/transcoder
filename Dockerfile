FROM crystallang/crystal:latest

WORKDIR /app
COPY build.sh shard.* ./
COPY src/ ./src
COPY public/ ./public
COPY samples/ ./samples

RUN apt update && apt install -y handbrake-cli
RUN ls -R
RUN ./build.sh

CMD ["./transcoder"]
