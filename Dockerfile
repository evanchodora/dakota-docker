FROM centos:7

# Install Dakota requirements and dependencies
RUN yum --setopt=tsflags=nodocs -y update && \
	yum --setopt=tsflags=nodocs -y install \
	wget \
	blas \
	blas-devel \
	boost \
	boost-devel \
	gcc \
	gcc-c++ \
	gcc-gfortran \
	gsl \
	gsl-devel \
	lapack \
	lapack-devel \
	cmake \
	make \
	openmpi \
	openmpi-devel \
	perl \
	python && \
	yum clean all

# Set some environment variables for Dakota
ENV INSTALL_DIR /opt/dakota
ENV PATH $INSTALL_DIR/bin:$INSTALL_DIR/share/dakota/test:$PATH
ENV PYTHONPATH $PYTHONPATH:$INSTALL_DIR/share/dakota/Python

WORKDIR /src

# Install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4.tar.gz && \
	tar xf cmake-3.* && \
	cd cmake-3.* && \
	./bootstrap --prefix=/usr/local && \
	make -j4 && \
	make install && \
	cd /src && rm -rf /src/* && \
	cmake --version

# Pull the Dakota source code from Sandia, extract, and delete, then build and install
RUN wget -O dakota.tar.gz "https://dakota.sandia.gov/sites/default/files/distributions/public/dakota-6.10-release-public.src.tar.gz" && \
	tar xf dakota.tar.gz && \
	rm dakota.tar.gz && \
	mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DHAVE_QUESO=ON -DDAKOTA_HAVE_GSL=ON /src/dakota-6.10.0.src && \
	make -j4 && \
	make install && \
	rm -rf /src/*

# Entrypoint and initial command
ENTRYPOINT [ "/bin/bash" ]
