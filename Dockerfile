FROM tensorflow/tensorflow:1.13.2-gpu-py3
LABEL maintainer="olala7846@gmail.com"

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    wget \
    git \
    unzip \
    curl \
    nano \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

# Install tensorflow/models require dependencies
COPY requirements.txt .
ENV DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y protobuf-compiler \
    tzdata \
    python3-pil \
    python3-lxml \
    python3-tk \
    python3-setuptools \
    && pip3 install -r requirements.txt \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

# Build ros 2 workspace
COPY bmcnn /usr/src/app/bmcnn
COPY libs /usr/src/app/libs
COPY savedmodels /usr/src/app/savedmodels
COPY testdata /usr/src/app/testdata

RUN sh -c 'cd usr/src/app/libs; python3 setup.py install'
WORKDIR /usr/src/app/
#CMD ["jupyter-lab --no-browser --allow-root --ip 0.0.0.0 --NotebookApp.custom_display_url=http://localhost:8888"]