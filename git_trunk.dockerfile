FROM ubuntu:plucky

# Install required dependencies

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    awscli git \
    g++ cmake libcurl4-openssl-dev libdeflate-dev libbz2-dev libjemalloc-dev libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*


# Clone Metagraph repository and initialize submodules
RUN git clone --recursive https://github.com/ratschlab/metagraph.git /opt/metagraph

WORKDIR /opt/metagraph

RUN git submodule update --init --recursive \
    && git submodule sync \
    && cd metagraph/external-libraries/sdsl-lite \
    && ./install.sh "$(pwd)"

# Build Metagraph
RUN mkdir metagraph/build && cd metagraph/build \
    && cmake .. \
    && make -j $(($(getconf _NPROCESSORS_ONLN) - 1))

# Add Metagraph binary to PATH
ENV PATH="/opt/metagraph/metagraph/build:${PATH}"
