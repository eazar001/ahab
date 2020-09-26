#!/bin/bash

python3 -m http.server 8081 &
swilgt -g "{'src/loader'}"

# kill the python server before exiting
ps ax | grep 'http.server' | head -n1 | awk '{print $1}' | xargs kill
