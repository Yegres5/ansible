FROM ubuntu:jammy AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS moon
ARG TAGS
RUN addgroup --gid 1000 mooning
RUN adduser --gecos mooning --uid 1000 --gid 1000 --disabled-password mooning
USER mooning
WORKDIR /home/mooning

FROM moon
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

