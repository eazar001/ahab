#!/bin/bash

python3 -m http.server 8081 &

if [ "$1" == "debug" ]; then
    swilgt -g "{'src/debug_loader'}"
else
    swilgt -g "{'src/loader'}"
fi

# kill the python server before exiting
ps ax | grep 'http.server' | head -n1 | awk '{print $1}' | xargs kill
