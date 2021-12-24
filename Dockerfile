FROM docker.io/python:3.9.7-bullseye

ARG DEBIAN_FRONTEND=noninteractive
# dolfin
RUN apt-get update -yqq && \
	apt-get install -yqq \
	build-essential \
	cmake \
	gfortran \
	liblapack3 liblapack-dev \
	libblas3 libblas-dev \
	libeigen3-dev \
	libboost-all-dev \
	petsc-dev \
	slepc-dev \
	&& \
	apt-get -qq purge && \
	apt-get -qq clean && \
	rm -rf /var/lib/apt/lists/*

# fenics
RUN pip install -U fenics-ffc
ENV FENICS_VERSION=2019.1.0.post0
RUN mkdir -p /tmp/src/

RUN git config --global user.email mm@clfx.cc
RUN git config --global user.name mm

#RUN apt-get update -yqq && apt-get install libopenmpi-dev
RUN cd /tmp/src/ && \
	git clone --branch=$FENICS_VERSION https://bitbucket.org/fenics-project/dolfin 
COPY *.patch /tmp/src/dolfin/
RUN cd /tmp/src/dolfin && \
	git am algorithm.patch && \
	git am boost.patch && \
	cd .. && \
	mkdir dolfin/build && cd dolfin/build && \
	cmake .. && make install

ENV PYBIND11_VERSION=2.2.3

RUN cd /tmp/src/ && \
	wget -nc --quiet https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz && \
	tar -xf v${PYBIND11_VERSION}.tar.gz && \
	cd pybind11-${PYBIND11_VERSION} && \
	mkdir build && cd build && \
	cmake -DPYBIND11_TEST=off .. && make install && \
	rm -rf v${PYBIND11_VERSION}.tar.gz

RUN cd /tmp/src/dolfin/python && \
	pip3 install .

# mshr
RUN apt-get update -yqq && \
	apt-get install -yqq \
	libgmp-dev \
	libmpfr-dev \
	&& \
	apt-get -qq purge && \
	apt-get -qq clean && \
	rm -rf /var/lib/apt/lists/*

RUN cd /tmp/src/ && \
	git clone --branch=2019.1.0 https://bitbucket.org/fenics-project/mshr && \
	mkdir mshr/build && cd mshr/build && \
	cmake .. && make install

RUN cd /tmp/src/mshr/python && \
	pip3 install .

RUN echo "source /usr/local/share/dolfin/dolfin.conf" >> /root/.profile
