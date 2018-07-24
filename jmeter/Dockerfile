FROM openjdk:8-jre-alpine

RUN apk update \
    && apk add python \
       py-pip \
    && rm -rf /var/cache/apk/* \
    && pip install argparse google-cloud-storage

VOLUME /tmp

COPY apache-jmeter-4.0.tgz /usr/

COPY test.jmx /jmeter/

COPY docker-entrypoint.sh /jmeter/

COPY upload.py /jmeter/

RUN cd /usr \
  && tar -xzf apache-jmeter-4.0.tgz \
  && rm apache-jmeter-4.0.tgz \
  && cd /jmeter \
  && chmod +x docker-entrypoint.sh

WORKDIR /jmeter

ENTRYPOINT ["/jmeter/docker-entrypoint.sh"]
