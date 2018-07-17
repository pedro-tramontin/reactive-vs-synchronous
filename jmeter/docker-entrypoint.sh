#!/bin/sh

# Create the output dir and its parents
mkdir -p $OUT_DIR

# Remove only the target output directory
rm -rf $OUT_DIR

# Call JMeter
/usr/apache-jmeter-4.0/bin/jmeter \
  -JSERVER_HOST=$SERVER_HOST \
  -JNUM_THREADS=$NUM_THREADS \
  -JRAMPUP_PERIOD=$RAMPUP_PERIOD \
  -JLOOP_COUNT=$LOOP_COUNT \
  -n \
  -f \
  -t test.jmx \
  -l $OUT_RESULTS \
  -e \
  -o $OUT_DIR
