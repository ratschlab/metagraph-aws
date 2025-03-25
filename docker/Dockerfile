FROM amazonlinux:latest

# Install system dependencies
RUN yum install -y aws-cli \
    && yum clean all

# Install Miniconda
RUN curl -sSLo /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Set Conda path
ENV PATH="/opt/conda/bin:$PATH"

# Install Metagraph using Conda
RUN conda create -n metagraph_env -c bioconda -c conda-forge metagraph -y

# Ensure environment auto-activates
RUN echo "source activate metagraph_env" >> ~/.bashrc
