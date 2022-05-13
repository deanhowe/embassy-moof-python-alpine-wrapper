#!/bin/sh

# A cheeky touch of moof-python-alpine.log to help keep the container running…
# so you can ssh in and have some fun.

touch /var/log/moof-python-alpine.log

exec tail -f /var/log/moof-python-alpine.log