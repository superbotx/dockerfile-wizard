#!/bin/bash

echo "FROM buildpack-deps:$(awk -F'_' '{print tolower($2)}' <<< $LINUX_VERSION)"

RUN apt-get update

echo "RUN wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz && \
  tar xzf Python-2.7.12.tgz && \
  rm Python-2.7.12.tgz && \
  cd Python-2.7.12 && \
  ./configure && \
  make install"

# install bats for testing
echo "RUN git clone https://github.com/sstephenson/bats.git \
  && cd bats \
  && ./install.sh /usr/local \
  && cd .. \
  && rm -rf bats"

# install dependencies for tap-to-junit
echo "RUN perl -MCPAN -e 'install TAP::Parser'"
echo "RUN perl -MCPAN -e 'install XML::Generator'"

# install lsb-release, etc., for testing linux distro
echo "RUN apt-get update && apt-get -y install lsb-release unzip"

echo "RUN sh -c 'echo \"deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main\" > /etc/apt/sources.list.d/ros-latest.list' \
  && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
  && apt-get update \
  && apt-get install ros-kinetic-desktop-full \
  && apt-cache search ros-kinetic \
  && rosdep init \
  && rosdep update \
  && echo \"source /opt/ros/kinetic/setup.bash\" >> ~/.bashrc \
  && source ~/.bashrc \
  && apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential"
