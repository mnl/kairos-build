ARG BASE_IMAGE=ghcr.io/kairos-io/hadron:v0.0.1

FROM quay.io/kairos/kairos-init:v0.7.0 AS kairos-init

FROM ${BASE_IMAGE} AS base-kairos

# Example: create a custom file
RUN touch /etc/myfile-exists

# Example static pod
COPY ./pod.yaml /etc/kubernetes/manifests/static-nginx.yaml

# "Kairosify" the image
RUN --mount=type=bind,from=kairos-init,src=/kairos-init,dst=/kairos-init \
    /kairos-init --stage install \
      --level debug \
      --model "generic" \
      --trusted "false" \
      --provider k3s \
      --provider-k3s-version "v1.35.0+k3s1" \
      --version "v0.0.1" \
    && \
    /kairos-init --stage init \
      --level debug \
      --model "generic" \
      --trusted "false" \
      --provider k3s \
      --provider-k3s-version "v1.35.0+k3s1" \
      --version "v0.0.1"
