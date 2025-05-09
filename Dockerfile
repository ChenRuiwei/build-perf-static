FROM debian:bookworm-slim AS builder

ARG LINUX_VERSION=6.13.7

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bison \
    build-essential \
    ca-certificates \
    clang \
    flex \
    git \
    libbabeltrace-dev \
    libcapstone-dev \
    libdw-dev \
    libelf-dev \
    libnuma-dev \
    libperl-dev \
    libpfm4-dev \
    libslang2-dev\
    libssl-dev \
    libtraceevent-dev \
    libtracefs-dev \
    libzstd-dev \
    llvm-dev \
    ncurses-dev \
    pkg-config \
    python3 \
    python3-dev \
    python3-setuptools \
    python-is-python3 \
    systemtap-sdt-dev \
    wget \
    && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${LINUX_VERSION}.tar.xz && \
    tar xf linux-${LINUX_VERSION}.tar.xz && mv linux-${LINUX_VERSION} linux && \
    rm -rf linux-${LINUX_VERSION}.tar.xz

WORKDIR /linux
RUN make -C tools LDFLAGS=-static perf

FROM scratch AS export
COPY --from=builder /linux/tools/perf/perf /
