FROM ubuntu:24.04

RUN apt update && apt upgrade -y

# general utils
RUN apt install -y curl           \
                dnsutils          \
                iproute2          \
                iputils-ping      \
                postgresql-client \
                redis-tools       \
                unzip             \
                vim

# Reqs for gcloud cli
RUN apt install -y apt-transport-https \
                ca-certificates        \
                gnupg

# Install gcloud cli
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg                                                      && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt update && apt install -y google-cloud-cli

# Install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip                                                                && \
    ./aws/install                                                                     && \
    rm -rf ./aws                                                                      && \
    rm -f awscliv2.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl                                                  && \
    rm -f kubectl

# Install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh                                                                         && \
    ./get_helm.sh                                                                                 && \
    rm -f get_helm.sh

# clean up
RUN apt-get autoremove -y         && \
    apt-get purge -y --autoremove && \
    rm -rf /var/lib/apt/lists/*
