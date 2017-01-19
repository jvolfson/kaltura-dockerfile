FROM kaltura/server:latest
MAINTAINER Yleisradio Oy

ARG KALTURA_CONTAINER_PORT

RUN echo "Using port: $KALTURA_CONTAINER_PORT"

# This dockerfile contains a pre-configure Kaltura backend server
# for Yleisradio local development

RUN sed -i -r "s/^Listen 80/\nListen $KALTURA_CONTAINER_PORT/g" /etc/httpd/conf/httpd.conf

COPY conf/config.sh /root/install/config.ans
COPY conf/secrets.sh /root/install/secrets.sh
COPY conf/install.sh /root/install/install.sh
RUN chmod 755 /root/install/install.sh

# actual kaltura backend installation
RUN /root/install/install.sh

ENTRYPOINT /sbin/init
