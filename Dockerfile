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
RUN git config --global user.email mm@clfx.cc
RUN git config --global user.name mm

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

#RUN apt-get update -yqq && apt-get install libopenmpi-dev
RUN mkdir -p /tmp/src/ && cd /tmp/src/ && \
	git clone https://bitbucket.org/fenics-project/dolfin
COPY patches.patch /tmp/src/dolfin/
RUN cd /tmp/src/dolfin && \
	git checkout 3eacdb46ed4e6dcdcbfb3b2f5eefa73f32e1b8a8 && \
	git am patches.patch && \
	cd .. && \
	mkdir dolfin/build && cd dolfin/build && \
	cmake .. && make install

ENV PYBIND11_VERSION=2.4.3

RUN mkdir -p /tmp/src/ && cd /tmp/src/ && \
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
	git clone https://bitbucket.org/fenics-project/mshr && \
	cd mshr && git checkout c27eb18f47cb35d27c863c2db584915659e64c7f && cd .. && \
	. /usr/local/share/dolfin/dolfin.conf && \
	mkdir mshr/build && cd mshr/build && \
	cmake .. && make install

RUN cd /tmp/src/mshr/python && \
	pip3 install .

RUN echo ". /usr/local/share/dolfin/dolfin.conf" >> /root/.bashrc
