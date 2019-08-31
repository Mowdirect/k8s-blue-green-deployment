ARG KUBE_VERSION="v1.14.3"

FROM alpine:3.6

RUN apk add --update ca-certificates && update-ca-certificates \
    && apk add --update curl \
    && apk add bash \
    && apk add jq \
    && apk add python \
    && apk add make \
    && apk add git \
    && apk add openssl \
    && apk add py-pip \
    && pip install yq \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

WORKDIR /config

RUN mkdir /app

COPY k8s-blue-green.sh /app

RUN chmod +x /app/k8s-blue-green.sh

CMD /app/k8s-blue-green.sh $SERVICE_NAME $DEPLOYMENT_NAME $NEW_VERSION true $HEALTH_SECONDS $NAMESPACE
