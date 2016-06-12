FROM alpine:latest

ARG GRAFANA_VERSION

RUN export GOPATH=/go \
    && PATH=$PATH:$GOPATH/bin \
    && apk add --update build-base nodejs go git mercurial \
    && mkdir -p /go/src/github.com/grafana && cd /go/src/github.com/grafana \
    && git clone https://github.com/grafana/grafana.git -b v${GRAFANA_VERSION}\
    && cd grafana \
    && go run build.go setup \
    && $GOPATH/bin/godep restore \
    && go run build.go build \
    && npm install \
    && npm install -g grunt-cli \
    && cd /go/src/github.com/grafana/grafana && grunt \
    && npm uninstall -g grunt-cli \
    && npm cache clear \
    && mkdir -p /opt/grafana/ && mkdir -p /var/lib/grafana && mkdir -p /opt/grafana/conf \
    && cp -a /go/src/github.com/grafana/grafana/bin/grafana-server /usr/bin/grafana-server \
    && cp -ra /go/src/github.com/grafana/grafana/public_gen /opt/grafana/public \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64" \
    && chmod +x /usr/bin/gosu \
    && go clean -i -r \
    && apk del --purge build-base nodejs go git mercurial \
    && rm -rf /go /tmp/* /var/cache/apk/* /root/.n* 

ADD ./defaults.ini /opt/grafana/conf/defaults.ini
ADD ./grafana /etc/services.d/grafana
ADD 01-grafana-dir /etc/fix-attrs.d/01-grafana-dir
RUN addgroup -g 45555 grafana && adduser -u 45555 -G grafana -D grafana

VOLUME ["/var/lib/grafana"]

#WebUI
EXPOSE 3000

ENTRYPOINT ["/init"]
