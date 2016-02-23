FROM alpine:3.3

MAINTAINER SneakyScampi

# We are running npm install with --unsafe-perm as we are running this with root.  Seeing as this root user is mapped to a normal user in the hostOS, there should not be an issue.  We can run with user nodejs, but need to make sure it can write to the openvpn server dir.  Permissions need to be setup accordingly.  Therefore this is noted as not a concern but on the todo list.

WORKDIR /root
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories \ 
	&& apk update && apk upgrade \
	&& apk add openvpn iptables bash git nodejs bash \
	&& apk add alpine-sdk autoconf automake libtool gettext bison flex ragel boost-dev \
	| tee /tmp/install.txt \
	&& git clone https://github.com/privateport/openvpn-webca.git \
	&& cd /root/openvpn-webca \
	&& npm cache clean && npm update -g npm && npm install --unsafe-perm \ 
	&& apk del `grep 'Installing' /tmp/install.txt | awk {'print $3'} | xargs echo` && rm -rf /tmp/install.txt \
	&& apk add git bash \
	&& git clone https://github.com/alexdw1/openssl-tools.git /tmp/openssl-tools && cd /tmp/openssl-tools && ./install.sh && rm -rf /tmp/openssl-tools

COPY config.sh /opt/
COPY start.sh /opt/
COPY assets/openvpn-templates /usr/local/share/openvpn/
COPY assets/usr/local/bin /usr/local/bin/
RUN chmod a+x /usr/local/bin/* 

EXPOSE 3000/tcp
CMD ["/opt/start.sh"]
