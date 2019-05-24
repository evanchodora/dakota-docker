# Set base image (Sandia uses CentOS/RHEL for development)
FROM centos:7

# Install Dakota requirements and dependencies
RUN yum --setopt=tsflags=nodocs -y update && \
	yum --setopt=tsflags=nodocs -y install \
	wget \
	blas blas-devel \
	boost boost-devel \
	gcc gcc-c++ \
	gcc-gfortran \
	gsl gsl-devel \
	lapack lapack-devel \
	cmake make \
	openmpi openmpi-devel
	perl \
	python && \
	yum clean all

# Set some environment variables for Dakota
ENV CMAKE_VER=3.14.4
ENV DAKOTA_VER=6.10
ENV INSTALL_DIR /opt/dakota
ENV PATH $INSTALL_DIR/bin:$INSTALL_DIR/share/dakota/test:$PATH
ENV PYTHONPATH $PYTHONPATH:$INSTALL_DIR/share/dakota/Python

WORKDIR /src

# Install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz && \
	tar xf cmake* && \
	cd cmake* && \
	./bootstrap --prefix=/usr/local && \
	make -j$(nproc) && \
	make install && \
	cd /src && rm -rf /src/* && \
	cmake --version

# Pull the Dakota source code from Sandia, extract, and delete, then build and install
RUN wget -O dakota.tar.gz "https://dakota.sandia.gov/sites/default/files/distributions/public/dakota-${DAKOTA_VER}-release-public.src.tar.gz" && \
	tar xf dakota.tar.gz && \
	rm dakota.tar.gz && \
	mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	-DHAVE_QUESO:BOOL=ON -DDAKOTA_HAVE_GSL:BOOL=ON \
	-DDAKOTA_HAVE_MPI:BOOL=TRUE \
	-DCMAKE_CXX_COMPILER:FILEPATH=/usr/lib64/openmpi/bin/mpicxx
	/src/dakota-${DAKOTA_VER}.0.src && \
	make -j$(nproc) && \
	make install && \
	rm -rf /src/*

# Entrypoint and initial command
ENTRYPOINT [ "dakota" ]
CMD [ "-v" ]
