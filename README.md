
This repository contains a docker file which can be used to build a docker image.
This docker file builds an image which can be used as a development environment for ESP32 boards. The image contains all the build tools which are required to build applications for ESP32 systems.
This docker file takes debian:latest as base system. 
The docker file is setup with a user:
	username: developer
	password: password
By default the container starts as this user and to perform instructions over sudo this password can be used.
For espressif toolchain, espressif idf version v5.2.2 is chosen by default. Download this version from github and exract it in the same folder as dockerfile. Since espidf is built on top of FreeRTOS, therefore this dockerfile can also be used for building applications for FreeRTOS.
This docker file is build and tested on linux systems.
By default zsh is selected as shell and a configuration file (.zshrc) is present with this docker file. This file will be copied while building the image.
Appropriate tools are installed in the image which can be used for building applications on Apache Nuttx platform.
Install git, make, cmake, bison, gcc, gdb and basic build tools in the host system.
Apache nuttx should be downloaded in host system and later this location will be mounted as a volume in the docker container. Download the zip file from here (https://nuttx.apache.org/download/) or follow the steps to download the source code from github. 

```zsh
mkdir nuttxspace
cd nuttxspace
git clone https://github.com/apache/nuttx.git nuttx
git clone https://github.com/apache/nuttx-apps apps 
```
Build using this command:

```zsh
docker buildx build -t embedded_dev:1.0 . --progress=plain 
```
create a container usign the below command:

```zsh
docker run -it --name=test_emb --device=/dev/ttyACM0:/dev/ttyACM0 --device=/dev/ttyACM1:/dev/ttyACM1 --volume=$SOFTWARE_DEV_DIR:/home/developer/Software_Dev_Dir embedded_dev:1.0
```
here:
	$SOFTWARE_DEV_DIR is the directory where nuttx source code is placed.
	/dev/ttyACM0 and /dev/ttyACM1 are the serial ports for ESP32 boards. Some boards have separate UART/JTAG and USB Serial ports. Ports should be cross checked once in "ls -l /dev/tty*'

Run the container:
```zsh
docker start -i test_emb
```


To download and install esp-idf tools from git while building the image, un-comment line 130 and comment out line 131

In the container, run:
```zsh
sudo chmod 777 /dev/tty*
```
This will grant serial port permissions

If host system does not have serial port permissions then add the user to dialout group (and uucp for Arch based systems)
```zsh
sudo usermod -a -G dialout,uucp $(whoami)
```

