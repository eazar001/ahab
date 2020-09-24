#!/bin/bash

python3 -m SimpleHTTPServer 8081 &
swilgt -g "{'src/loader'}"

# kill the python server before exiting
ps ax | grep SimpleHTTPServer | head -n1 | awk '{print $1}' | xargs kill
