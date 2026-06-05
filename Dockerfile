FROM ghcr.io/gem5/ubuntu-24.04_all-dependencies:v24-0

ARG JOBS=2

RUN git config --global --add safe.directory /gem5

# Instala toolchain RISC-V e make
RUN apt-get update && apt-get install -y \
    gcc-riscv64-linux-gnu \
    make \
    && rm -rf /var/lib/apt/lists/*

COPY ./gem5 /gem5

RUN cd /gem5 && python3 /usr/bin/scons build/RISCV/gem5.opt -j${JOBS}

WORKDIR /gem5
CMD ["bash"]