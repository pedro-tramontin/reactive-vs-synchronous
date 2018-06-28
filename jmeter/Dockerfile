FROM openjdk:8-jre-alpine
VOLUME /tmp
COPY apache-jmeter-4.0.tgz /usr/
COPY test.jmx /jmeter/
COPY docker-entrypoint.sh /jmeter/
RUN cd /usr \
  && tar -xzf apache-jmeter-4.0.tgz \
  && rm apache-jmeter-4.0.tgz \
  && cd /jmeter \
  && chmod +x docker-entrypoint.sh
WORKDIR /jmeter
ENTRYPOINT ["/jmeter/docker-entrypoint.sh"]
