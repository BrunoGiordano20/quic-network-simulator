FROM ubuntu:16.04 as builder

RUN apt-get update && \
    apt-get install -y build-essential git cmake software-properties-common \
                       zlib1g-dev libevent-dev

RUN add-apt-repository ppa:gophers/archive && \
    apt-get update && \
    apt-get install -y golang-1.9-go && \
    cp /usr/lib/go-1.9/bin/go* /usr/bin/.

RUN mkdir /src
WORKDIR /src

RUN git clone https://boringssl.googlesource.com/boringssl && \
    cd boringssl && \
    git checkout a2278d4d2cabe73f6663e3299ea7808edfa306b9 && \
    cmake . && \
    make

RUN git clone https://github.com/litespeedtech/lsquic.git && \
    cd lsquic && \
    git submodule init && \
    git submodule update && \
    cmake -DBORINGSSL_DIR=/src/boringssl . && \
    make
 
RUN cd lsquic && cp bin/http_client /usr/bin/ && cp bin/http_server /usr/bin

FROM martenseemann/quic-network-simulator-endpoint:latest

WORKDIR /lsquic

COPY --from=builder  src/lsquic/bin/http_client src/lsquic/bin/http_server ./

RUN mkdir /www && mkdir /downloads && mkdir /certs && \
    openssl genrsa 2048 > /certs/priv.key && chmod 400 /certs/priv.key && \
    openssl req -new -x509 -nodes -sha256 -days 365 -subj "/C=IT/ST=Italy/L=Italy/O=Unina/OU=../CN=.." -key /certs/priv.key -out /certs/cert.crt && \
    cat /certs/priv.key > /certs/cert.pem && cat /certs/cert.crt >> /certs/cert.pem

COPY run_endpoint.sh .
RUN chmod +x run_endpoint.sh

COPY start_server.sh .
RUN chmod +x start_server.sh

COPY start_client.sh .
RUN chmod +x start_client.sh

ENTRYPOINT [ "./run_endpoint.sh" ]