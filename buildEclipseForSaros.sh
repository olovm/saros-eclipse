#! /bin/bash

USER=$1
USERID=$2
DOCKERGROUPID=$3
NOCACHE=$4
echo "running buildEclipseForSaros.sh..."

echo "Testing for container runtimes...."
CONTAINERRUNTIME=podman;
DOCKER_EXISTS=$(command -v docker)
echo "Docker size: "${#DOCKER_EXISTS}
if [ ${#DOCKER_EXISTS} -gt 0 ]; then
	CONTAINERRUNTIME=docker;
fi
echo "Container runtime will be "${CONTAINERRUNTIME}

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipse202412forsaros1
elif [ ! $USERID ]; then
	echo you must specify the userid to be used when building eclipse202412forsaros1, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ]; then
	echo you must specify the dockergroupid to be used when building eclipse202412forsaros1, use: getent group docker 
else
	#for possibly newer version of from: X
	#docker build --pull --no-cache --build-arg user=$USER --build-arg dockergroupid=$DOCKERGROUPID -t eclipseforsarosoxygen2 saros-eclipse/docker/
#	 --no-cache \
	if [ ! $NOCACHE ]; then
		${CONTAINERRUNTIME} build \
		 --build-arg user=$USER \
		 --build-arg userid=$USERID \
		 --build-arg dockergroupid=$DOCKERGROUPID \
		 -t eclipse202412forsaros1 saros-eclipse/docker/
	else
		${CONTAINERRUNTIME} build --no-cache --pull \
		 --build-arg user=$USER \
		 --build-arg userid=$USERID \
		 --build-arg dockergroupid=$DOCKERGROUPID \
		 -t eclipse202412forsaros1 saros-eclipse/docker/
	fi
	#${CONTAINERRUNTIME} build --build-arg user=$USER -t eclipseforsarosoxygen2 saros-eclipse/docker/
	#cd saros-eclipse/docker/
	#docker-compose build --build-arg user=$USER eclipseforsarosoxygen2
	#docker-compose build --no-cache --build-arg user=$USER eclipseforsarosoxygen2
fi
