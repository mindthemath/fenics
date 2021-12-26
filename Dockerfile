ARG PYTHON_TAG=3.9.7-bullseye
FROM docker.io/python:$PYTHON_TAG

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
RUN git config --global user.email fenics@dockerhost
RUN git config --global user.name fenics

RUN mkdir -p /tmp/src/ && cd /tmp/src/ && \
	git clone https://bitbucket.org/fenics-project/ufl && \
	cd ufl && pip install . && cd .. && \
	git clone https://bitbucket.org/fenics-project/dijitso && \
	cd dijitso && pip install . && cd .. &&\
	git clone https://bitbucket.org/fenics-project/fiat && \
	cd fiat && pip install . && cd .. && \
	git clone https://bitbucket.org/fenics-project/ffc && \
	cd ffc && \
	sed -i 's|2021.1.0|2019.2.0.dev0|g' setup.py && \
	pip install . && cd .. && \
	rm -rf /tmp/src/*

ENV PYBIND11_VERSION=2.4.3
RUN mkdir -p /tmp/src/ && cd /tmp/src/ && \
	wget -nc --quiet https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz && \
	tar -xf v${PYBIND11_VERSION}.tar.gz && \
	cd pybind11-${PYBIND11_VERSION} && \
	mkdir build && cd build && \
	cmake -DPYBIND11_TEST=off .. && make install && cd / && \
	rm -rf /tmp/src/*

COPY patches.patch /tmp/latest.patch
RUN mkdir -p /tmp/src/ && cd /tmp/src/ && \
	git clone https://bitbucket.org/fenics-project/dolfin && \
	cd dolfin && \
	git checkout 3eacdb46ed4e6dcdcbfb3b2f5eefa73f32e1b8a8 && \
	git am /tmp/latest.patch && \
	mkdir build && cd build && \
	cmake .. && make install && cd .. && \
	cd python && pip3 install . && cd / && \
	rm -rf /tmp/src/*

# mshr
RUN apt-get update -yqq && \
	apt-get install -yqq \
	libgmp-dev \
	libmpfr-dev \
	&& \
	apt-get -qq purge && \
	apt-get -qq clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/src/ && cd /tmp/src/ && \
	git clone https://bitbucket.org/fenics-project/mshr && \
	cd mshr && \
	git checkout c27eb18f47cb35d27c863c2db584915659e64c7f && \
	. /usr/local/share/dolfin/dolfin.conf && \
	mkdir build && cd build && \
	cmake .. && make install && cd .. && \
	cd python && pip3 install . && cd / && \
	rm -rf /tmp/src/*

RUN echo ". /usr/local/share/dolfin/dolfin.conf" >> /root/.bashrc
