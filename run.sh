#!/bin/bash

python -m SimpleHTTPServer 8081 &
swilgt -g "{'src/loader'}"
