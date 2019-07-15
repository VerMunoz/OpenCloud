FROM python:3.6.3-alpine3.6

RUN apk add --no-cache -U \
      zeromq-dev

COPY requirements.txt /

RUN apk add --no-cache -U --virtual build-deps \
      g++ \
    && pip install -r /requirements.txt \
    && apk del build-deps
RUN mkdir /locust
WORKDIR /locust

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
