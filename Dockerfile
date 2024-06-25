#----------------- This is the docker for Embedded Build system Tool chain--------
#  This image contains all the build tools specifically required for:
#    Espressif Systems
#    RTOS:  Apache NUTTX
#    RTOS: FreeRtos comes with esp-idf
#   This docker file is tested on linux host OS.
# 
# Author: Devansh Purohit ("devansh.purohit@proton.me")
# Date created: 10.06.2024


# -------------- Lisence --------------------
# Copyright 2024 Devansh Purohit

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#----------------------------------------------------------------------
# This image is built using debian latest version

FROM debian:latest
LABEL maintainer="Devansh Purohit"

RUN apt-get update && \
apt-get upgrade -y

#--------------------------------------------
#  Installing all the required packages
#--------------------------------------------
RUN apt-get install -y -qq \
bison \
sudo \
curl \
patch \
xz-utils \
git \
clang \
cmake \
flex \
g++ \
gawk \
gperf \
libncurses5-dev \
libncursesw5-dev \
make \
ninja-build \
nodejs \
npm \
python3 \
gettext \
texinfo \
automake \
libtool \
pkg-config \
build-essential \
genromfs \
libgmp-dev \
libmpc-dev \
libmpfr-dev \
binutils-dev \
libelf-dev \
libexpat-dev \
gcc-multilib \
g++-multilib \
picocom \
u-boot-tools \
util-linux \
gcc \
zsh \
python3-pip \
python3-venv \
ccache \
dfu-util \
libusb* \
clang-tidy \
kconfig-frontends \
nano \
git \
unzip \
&& rm -rf /var/lib/apt/lists/*





#--------------------------------------------------------------------------
# Changing group permissions for /dev/tty* to add dialout group users
# Creating a user
# Username: developer
# password: password
# User will be added to group: dialout users uucp sudo 
# ------------------------------------------------------------------------
RUN chmod 777 /dev/tty*
RUN useradd -ms /bin/zsh developer; echo 'developer:password' | chpasswd
RUN usermod -a -G dialout,users,uucp,sudo,root  developer
USER developer
ARG _USER=developer
WORKDIR /home/$_USER/




#------- Creating a Volume for mount point -------
#  in container: /home/user/software_dev_dir
#  in Host file system: define at runtime 
#  all the nuttx files will be stored in host file system and mounted at this volume in container
#------------------------------------------------
VOLUME /home/$_USER/Software_Dev_Dir
ENV SOFTWARE_DEV_DIR=/home/$_USER/Software_Dev_Dir
ENV NUTTX=$SOFTWARE_DEV_DIR/nuttxspace/nuttx




#-------------------------------------------------------------
# Building ESP tools latest stable release v.5.2.2
# Building for esp32s3
# Un-comment the commands for git and comment COPY command 
#  want to download from git directly.
#-------------------------------------------------------------
RUN mkdir $HOME/esp
#RUN git clone -b v5.2.2 --recursive https://github.com/espressif/esp-idf.git $HOME/esp/esp-idf-v5.2.2
COPY esp-idf-v5.2.2 /home/$_USER/esp/esp-idf-v5.2.2/
RUN ls -a /home/developer/esp/esp-idf-v5.2.2
WORKDIR /home/$_USER/esp/esp-idf-v5.2.2
RUN ./install.sh esp32s3
RUN pip3 install imgtool 

#-----------------------------------------------------------------------------
# Another way to use esp idf is to install in host system and then mount the 
# host system directories as docker volumes. 
# ------------------------------------------------------------------------------
# VOLUME /home/$_USER/esp
# VOLUME /home/$_USER/.espressif
#----  Mount the host dirs as volumes, and use host tools for espidf  --------

WORKDIR $SOFTWARE_DEV_DIR
COPY .zshrc /home/$_USER
CMD ["/bin/zsh"]
