#! /bin/bash
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
echo basedir: $BASEDIR

USER=$(id -u -n)

echo 
echo starting eclipse using:
echo userName: $USER
echo 
echo "Testing for container runtimes...."
CONTAINERRUNTIME=podman;
DOCKER_EXISTS=$(command -v docker)
echo "Docker size: "${#DOCKER_EXISTS}
if [ ${#DOCKER_EXISTS} -gt 0 ]; then
	CONTAINERRUNTIME=docker;
fi
echo "Container runtime will be "${CONTAINERRUNTIME}

if [ ! $USER ]; then
  	echo "You must specify the userName used when starting eclipse202303forsaros3"
else
cd eclipse202303forsaros3
${CONTAINERRUNTIME} run --rm -ti --privileged  --ipc=host \
 --env="QT_X11_NO_MITSHM=1"\
 --env="NO_AT_BRIDGE=1"\
 -e DISPLAY=$DISPLAY \
 -e XDG_RUNTIME_DIR=/tmp \
 -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
 -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /usr/lib64/dri:/usr/lib64/dri\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket\
 -v INSTALLDIR/workspace:/home/$USER/workspace\
 -v INSTALLDIR/eclipse:/home/$USER/eclipse\
 -v INSTALLDIR/.eclipse:/home/$USER/.eclipse\
 -v INSTALLDIR/.saros:/home/$USER/.saros\
 -v PARENTDIR/m2:/home/$USER/.m2\
 -v PARENTDIR/eclipseP2:/home/$USER/.p2\
 -v PARENTDIR/.gitconfig:/home/$USER/.gitconfig\
 -v PARENTDIR/ssh:/home/$USER/.ssh\
 -v PARENTDIR/gradle:/home/$USER/.gradle\
 -e user=$USER\
 -e HOSTBASEDIR=$BASEDIR\
 --network=eclipseForSarosNet\
 --name eclipse202303forsaros3\
 --network-alias=eclipse\
 eclipse202303forsaros3 $2
 cd ../
fi
