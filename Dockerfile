FROM ros:kinetic-ros-core-xenial

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-base=1.3.1-0* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get install python3-venv
