#!/usr/bin/env bash

# if we pass an argument
# sleep for that many seconds
# else just clear the pasteboard

if [ -n "$1" ]; then
    sleep $1
fi

echo '' | pbcopy 

