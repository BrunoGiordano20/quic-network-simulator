#!/bin/bash

./setup.sh
./wait-for-it.sh sim:57832 -s -t 10

/bin/bash

# if [ "$IPERF_ACTIVATION" == "y" ]; then
#   if [ "$ROLE" == "server" ]; then
#     ./wait-for-it.sh $CLIENT:5001 -s -t 10
#     iperf -c $CLIENT -b $IPERF_BAND -u -t 360 -e -i 1
#   else
#     iperf -i 1 -u -s -p 5001
#   fi
# else
#   sleep infinity
# fi