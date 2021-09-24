FROM ubuntu:latest

LABEL maintainer="Matthew Zito (goldmund)"
LABEL org.opencontainers.image.source="https://github.com/MatthewZito/docker-dev-env"

# avoid deb loader issues; we don't pass this in ENV because we want it to be ephemeral
ARG DEBIAN_FRONTEND=noninteractive
# set tz now; else will hang
ENV TZ=America/Vancouver

RUN apt-get update && \
  apt-get install -y \
  # get tz database
  tzdata \
  sudo \
  vim \
  curl \
  wget \
  git-core \
  locales \
  nodejs npm && \
  # set locale
  locale-gen en_US.UTF-8 && \
  # add dev user
  adduser --quiet --disabled-password \
  --shell /bin/bash --home /home/dev \
  # set gecos header
  --gecos "User" dev && \
  # manual easy password
  echo "dev:pass" | chpasswd && usermod -aG sudo dev

# golang install
RUN mkdir tmpgo && cd /tmpgo && \
  wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz -O package.tar.gz && \
  sudo tar -xvf package.tar.gz && \
  sudo mv go /usr/local

ENV GOROOT /usr/local/go
ENV GOPATH "$HOME/go"
ENV PATH "$GOPATH/bin:$GOROOT/bin:$PATH"

CMD ["bin/bash"]
