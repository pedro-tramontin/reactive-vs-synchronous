#!/bin/sh

rm -rf out/report

/usr/apache-jmeter-4.0/bin/jmeter \
  -JSERVER_HOST=$SERVER_HOST \
  -JNUM_THREADS=$NUM_THREADS \
  -JRAMPUP_PERIOD=$RAMPUP_PERIOD \
  -JLOOP_COUNT=$LOOP_COUNT \
  -n \
  -f \
  -t test.jmx \
  -l out/results.csv \
  -e \
  -o out/report
