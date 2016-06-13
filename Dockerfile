FROM alpine:latest

ARG GRAFANA_VERSION

RUN export GOPATH=/go \
    && PATH=$PATH:$GOPATH/bin \
    && apk add --update build-base nodejs go git mercurial \
    && mkdir -p /go/src/github.com/grafana && cd /go/src/github.com/grafana \
    && git clone https://github.com/grafana/grafana.git -b v${GRAFANA_VERSION} \
    && cd grafana \
    && go run build.go setup \
    && $GOPATH/bin/godep restore \
    && go run build.go build \
    && npm install \
    && npm install -g grunt-cli \
    && cd /go/src/github.com/grafana/grafana && grunt \
    && npm uninstall -g grunt-cli \
    && npm cache clear \
    && mkdir -p /var/lib/grafana && mkdir -p /usr/share/grafana/public \
    && cp -a /go/src/github.com/grafana/grafana/bin/grafana-server /usr/sbin/grafana-server \
    && cp -a /go/src/github.com/grafana/grafana/bin/grafana-cli /usr/sbin/grafana-cli \
    && cp -ra /go/src/github.com/grafana/grafana/public_gen/* /usr/share/grafana/public \
    && mkdir /usr/share/grafana/conf && mkdir /usr/share/grafana/vendor \
    && cp -a /go/src/github.com/grafana/grafana/conf/*.ini /usr/share/grafana/conf \
    && mkdir /etc/grafana \
    && cp -a /go/src/github.com/grafana/grafana/conf/*.toml /etc/grafana \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64" \
    && chmod +x /usr/bin/gosu \
    && go clean -i -r \
    && apk del --purge build-base nodejs go git mercurial \
    && rm -rf /go /tmp/* /var/cache/apk/* /root/.n* 

COPY ./grafana.ini /etc/grafana/grafana.ini

RUN addgroup -g 45555 grafana && adduser -u 45555 -G grafana -D grafana

VOLUME ["/var/lib/grafana", "/var/lib/grafana/plugins", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]
