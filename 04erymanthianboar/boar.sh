#!/bin/bash
SCRIPT="uri.sh"
TIME="8:42 AM 12/21/2018"
TEST="now + 1minute"

apt-get install at -y > /dev/null

at $TIME < $SCRIPT
