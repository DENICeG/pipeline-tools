FROM alpine:3.14 as helm
RUN apk add --update --no-cache curl openssl bash
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > /tmp/get_helm.sh
RUN chmod a+x /tmp/get_helm.sh
RUN /tmp/get_helm.sh -v v3.4.2

FROM sebidude/yaml-renderer:v1.4.7 as yaml-renderer
FROM sebidude/kubecrypt:v0.6.1-1.15 as kubecrypt
FROM sebidude/kubeinfo:v0.1.0-1.15 as kubeinfo
FROM sebidude/porecry:v0.1.5 as porecry
FROM sensu/sensu:6.5.4 as sensu


# create the tools image
FROM alpine:3.14

RUN apk upgrade
RUN apk add --update --no-cache curl bash git docker make jq bind-tools gettext
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/bin
COPY --from=yaml-renderer /usr/bin/yaml-renderer /usr/bin/yaml-renderer
COPY --from=kubecrypt /usr/bin/kubecrypt /usr/bin/kubecrypt
COPY --from=kubeinfo /usr/bin/kubeinfo /usr/bin/kubeinfo
COPY --from=porecry /usr/bin/porecry /usr/bin/porecry
COPY --from=sensu /usr/local/bin/sensuctl /usr/bin/sensuctl
COPY --from=helm /usr/local/bin/helm /usr/bin/helm
