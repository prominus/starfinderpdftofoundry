# Container to build javascript from C++ code. As ths QPDF library is a dependency this installs QPDF & QPDF Dev Libraries.

FROM emscripten/emsdk:3.1.40 as base
LABEL maintainer="Cody LeClair <prominus001@gmail.com>"

# Set the user to not be root. This avoids needing to change owners of output files
# Based on the following blog: https://nickjanetakis.com/blog/running-docker-containers-as-a-non-root-user-with-a-custom-uid-and-gid
ARG UID=1000
ARG GID=1000

# Create a folder to place the downloaded QPDF source code
WORKDIR /home/Downloads

# TODO: Remove this commented out code if package manager versions of QPDF are sufficient
# RUN wget --show-progress -v https://github.com/qpdf/qpdf/releases/download/v11.4.0/qpdf-11.4.0.tar.gz; \
#     tar -xvf qpdf-11.4.0.tar.gz;    \
#     cd qpdf-11.4.0;                 \
    # cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo; \
    # cmake --build build --parallel --target libqpdf libqpdf_static; \
    # cmake --install build --component lib; \
    # cmake --install build --component dev; \
    # cpack;                \

# Install qpdf and create non root user
# The packages libjsoncpp-dev libjsoncpp-doc libjsoncpp1 are for JSON reading
# The libwebp-dev package is for saving images to webp
RUN sudo apt-get update &&          \
    sudo apt-get -y install build-essential gdb cmake zlib1g-dev libjpeg-dev libgnutls28-dev libssl-dev libjsoncpp-dev libjsoncpp-doc libjsoncpp1 libtiff-tools libwebp-dev qpdf libqpdf-dev ghostscript; \
# User created in original container
# Can be found in source code here https://github.com/trzecieu/emscripten-docker/blob/master/docker/trzeci/emscripten-slim/Dockerfile#L352
    groupmod -g "${GID}" emscripten && usermod -u "${UID}" -g "${GID}" emscripten 

# set user and directory
USER emscripten 
WORKDIR /home/emscripten 