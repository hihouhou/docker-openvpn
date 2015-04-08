#
# Openvpn server Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

MAINTAINER hihouhou < hihouhou@hihouhou.com >

# Update & install packages
RUN apt-get update && \
    apt-get install -y openvpn openssl

# path for openvpn
WORKDIR /etc/openvpn/
ENV KEYS_DIR /etc/openvpn/easy-rsa/keys/
ENV OPENVPN_DIR /etc/openvpn/


# copy openvpn.cfg and fixed ip
COPY server.conf ${OPENVPN_DIR}
COPY ipp.txt ${OPENVPN_DIR}

# copy files for easy-rsa
RUN mkdir -p /etc/openvpn/easy-rsa/keys
COPY hihouhou.crt ${KEYS_DIR}
COPY hihouhou.key ${KEYS_DIR}
COPY dh1024.pem ${KEYS_DIR}
COPY ta.key ${KEYS_DIR}
COPY ca.crt ${KEYS_DIR}

#create log directory
RUN mkdir /var/log/openvpn

# if you want to generate this file
#RUN ls /etc/openvpn/easy-rsa/
#RUN cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
#RUN ls /etc/openvpn/easy-rsa/
#RUN cd /etc/openvpn/easy-rsa && \ 
#/bin/bash -c "source vars" && \
#./clean-all && \
#./build-dh && \
#./pkitool --initca && \
#./pkitool --server server && \
#openvpn --genkey --secret keys/ta.key

# Set up ownership
RUN chown -R root: *

EXPOSE 1701

CMD ['openvpn', '--config /etc/openvpn/server.conf']
