FROM centos:7

MAINTAINER hyan

RUN yum -y update \
&& yum -y install mpich mpich-devel gcc gcc-c++ make git autoconf automake libtool python-devel numpy bison bison-devel flex flex-devel llvm llvm-devel boost boost-devel zlib zlib-devel zlib-static mesa-libGLU mesa-libGLU-devel mesa-libOSMesa-devel \
&& yum clean all

# ADD cmake-3.6.2.tar.gz /
# RUN cd /cmake-3.6.2 \
# && ./configure \
# && gmake -j8 \
# && gmake install \
RUN curl -O https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz \
&& tar -xvf cmake-3.6.2.tar.gz \
&& rm -f cmake-3.6.2.tar.gz \
&&cd /cmake-3.6.2 \
&& ./configure \
&& gmake -j8 \
&& gmake install \

&& rm -rf /cmake-3.6.2

COPY install_mesa.sh /mesa-12.0.3/

# ADD mesa-12.0.3.tar.gz /
# RUN cd /mesa-12.0.3 \
# && bash install_mesa.sh \
RUN curl -O https://mesa.freedesktop.org/archive/12.0.3/mesa-12.0.3.tar.gz \
&& tar -xvf mesa-12.0.3.tar.gz \
&& rm -f mesa-12.0.3.tar.gz \
&& cd /mesa-12.0.3 \
&& bash install_mesa.sh \

&& rm -rf /mesa-12.0.3

# ADD FFmpeg.tar.gz /
# RUN cd /FFmpeg \
# && ./configure --disable-yasm --enable-shared \
# && make -j8 \
# && make install \
RUN git clone https://github.com/FFmpeg/FFmpeg /FFmpeg \
&& cd /FFmpeg \
&& ./configure --disable-yasm --enable-shared \
&& make -j8 \
&& make install \

&& rm -rf /FFmpeg 

COPY install.sh /root/build/

# ADD ParaView_src.tar.gz /root/
# RUN cd /root/build \
# && bash install.sh \
RUN git clone https://github.com/Kitware/ParaView.git /root/ParaView_src \
&& cd /root/ParaView_src \
&& git config submodule.VTK.url https://github.com/Kitware/VTK.git \
&& git checkout v5.4.0 \
&& git submodule init \
&& git submodule update \
&& cd /root/build \
&& bash install.sh \

&& rm -rf /root/ParaView_src \
&& rm -rf /root/build \

&& yum -y remove gcc gcc-c++ git make

# ADD visualizer-2.2.2.tar.gz /opt/
RUN cd /opt \
&& curl -o visualizer-2.2.2.tar.gz https://codeload.github.com/Kitware/visualizer/tar.gz/v2.2.2 \
&& tar -xvf visualizer-2.2.2.tar.gz \
&& rm -f visualizer-2.2.2.tar.gz 

ENV VISUALIZER_HOME=/opt/visualizer-2.2.2
ENV PARAVIEW_HOME=/root
ENV PATH=$PATH:/usr/lib64/mpich/bin:$PARAVIEW_HOME/bin

CMD /bin/bash

