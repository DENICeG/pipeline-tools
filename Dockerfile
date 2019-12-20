FROM alpine:3.10 as helm
RUN apk add --update --no-cache curl openssl bash
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > /tmp/get_helm.sh
RUN chmod a+x /tmp/get_helm.sh
RUN /tmp/get_helm.sh


FROM sebidude/yaml-renderer:v1.4.7 as yaml-renderer
FROM sebidude/kubecrypt:v0.4.1-1.15 as kubecrypt
FROM sebidude/kubeinfo:v0.1.0-1.15 as kubeinfo
FROM sensu/sensu:5.16.1 as sensu


# create the tools image
FROM alpine:3.10

RUN apk add --update --no-cache curl bash git docker make jq bind-tools gettext
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/bin
COPY --from=yaml-renderer /usr/bin/yaml-renderer /usr/bin/yaml-renderer
COPY --from=kubecrypt /usr/bin/kubecrypt /usr/bin/kubecrypt
COPY --from=kubeinfo /usr/bin/kubeinfo /usr/bin/kubeinfo
COPY --from=sensu /usr/local/bin/sensuctl /usr/bin/sensuctl
COPY --from=helm /usr/local/bin/helm /usr/bin/helm
