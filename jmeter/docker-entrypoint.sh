#!/bin/sh

FILE_COMPACTED=${REPORT_NAME}.tar.gz

# Create the output dir and its parents
mkdir -p /jmeter/out/${REPORT_NAME}

# Call JMeter
/usr/apache-jmeter-4.0/bin/jmeter \
  -JSERVER_HOST=${SERVER_HOST} \
  -JNUM_THREADS=${NUM_THREADS} \
  -JRAMPUP_PERIOD=${RAMPUP_PERIOD} \
  -JLOOP_COUNT=${LOOP_COUNT} \
  -n \
  -f \
  -t test.jmx \
  -l /jmeter/out/${REPORT_NAME}/results.csv \
  -e \
  -o /jmeter/out/${REPORT_NAME}/report

cd /jmeter/out \
  && tar -czf ${FILE_COMPACTED} ${REPORT_NAME} \
  && cd /jmeter/

python upload.py ${PROJECT} ${BUCKET_NAME} out/${FILE_COMPACTED} ${FILE_COMPACTED}
