FROM golang

ARG APP=product-svc
ENV APP $APP
ENV GOPROXY https://goproxy.io,direct
ENV CONF_PROVIDER_FILE_PATH /build/$APP/profiles/dev/server.yml
ENV APP_LOG_CONF_FILE /build/$APP/profiles/dev/log.yml
ENV SEATA_CONF_FILE /build/$APP/profiles/dev/seata.yml
COPY . /build

RUN go env -w GOSUMDB=off
RUN cd /build/$APP/app && go build

ENTRYPOINT /build/$APP/app/app