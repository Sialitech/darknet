FROM resinplayground/jetson-nano-cuda-cudnn-opencv:v0.2-slim
LABEL maintainer "Enrique Pernia"

RUN apt-get update && apt-get upgrade -y && apt-get install -y && \
	apt-get install -y  python3.7-dev clang-format wget apt-utils build-essential\
	autoconf automake libtool libopencv-dev git\
	locales \
  	software-properties-common \
	python3-pip

RUN git clone https://github.com/Sialitech/darknet.git
WORKDIR darknet
RUN git checkout api
COPY Makefile Makefile
RUN make
WORKDIR /app
RUN mv /usr/src/app/darknet/libdarknet.so /app/
RUN mv /usr/src/app/darknet/darknet.py /app/
RUN mv /usr/src/app/darknet/darknet_images.py /app/
COPY ./weights/ ./weights/
COPY main.py /app
RUN ls
RUN ls ./weights

#Instalacion VNCC nvidia
RUN python3.7 -m pip install scikit-build
RUN  apt-get install -y libgstreamer1.0-dev  libgstreamer1.0 libgstreamer-plugins-base1.0-dev libgtk2.0-dev libssl-dev
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz && \
tar -xf cmake-3.16.5.tar.gz && \
cd cmake-3.16.5 && \
./configure && \
make && \
make install

ENTRYPOINT ["python3", "main.py"]