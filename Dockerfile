FROM python:3.8.13-alpine3.15 as builder

# INSTALL jq - for editing JSON 
RUN apk update && apk add --no-cache jq python3 python3-dev gcc g++ openssl musl-dev linux-headers libffi-dev postgresql-dev

# INSTALL YQ - for editing YAML
RUN wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_arm \
    && chmod a+x /usr/local/bin/yq

WORKDIR /app


ADD ./docker_entrypoint.sh /docker_entrypoint.sh
RUN chmod a+x /docker_entrypoint.sh

ENTRYPOINT ["/docker_entrypoint.sh"]
