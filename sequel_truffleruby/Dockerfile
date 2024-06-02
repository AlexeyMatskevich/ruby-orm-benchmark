ARG DISTRO_NAME=bookworm

FROM debian:$DISTRO_NAME-slim

ARG DISTRO_NAME=bookworm
ENV LANG C.UTF-8

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    ca-certificates \
    libffi-dev \
    libgmp-dev \
    libssl-dev \
    libyaml-dev \
    gnupg2 \
    curl \
    less \
    git \
    unzip \
    wget \
    tar

# Install PostgreSQL dependencies
ARG PG_MAJOR=16
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    gpg --dearmor -o /usr/share/keyrings/postgres-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] https://apt.postgresql.org/pub/repos/apt/" \
    $DISTRO_NAME-pgdg main $PG_MAJOR | tee /etc/apt/sources.list.d/postgres.list > /dev/null
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$PG_MAJOR && \
    psql --version

ARG TRUFFLERUBY_VERSION
RUN set -eux ;\
    wget -q https://github.com/oracle/truffleruby/releases/download/graal-$TRUFFLERUBY_VERSION/truffleruby-jvm-$TRUFFLERUBY_VERSION-linux-amd64.tar.gz ;    tar -xzf truffleruby-jvm-$TRUFFLERUBY_VERSION-linux-amd64.tar.gz -C /usr/local --strip-components=1 ;\
    rm truffleruby-jvm-$TRUFFLERUBY_VERSION-linux-amd64.tar.gz ;\
    /usr/local/lib/truffle/post_install_hook.sh ;\
    truffleruby-polyglot-get java ;\
    ruby --version ;\
    gem --version ;\
    bundle --version

ENV PATH="/usr/local/jvm/bin:${PATH}"
ENV JAVA_HOME="/usr/local/jvm"

# don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH

# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Document that we're going to expose port 3000
EXPOSE 3000

# Use Bash as the default command
CMD ["/usr/bin/bash"]
