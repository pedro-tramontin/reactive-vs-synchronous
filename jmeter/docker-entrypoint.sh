#!/bin/sh

rm -rf out/report

/usr/apache-jmeter-4.0/bin/jmeter \
  -JSERVER_HOST=$SERVER_HOST \
  -n \
  -f \
  -t test.jmx \
  -l out/results.csv \
  -e \
  -o out/report
