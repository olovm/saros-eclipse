#! /bin/bash

USER=$(id -u -n)
USERID=$(id -u)
DOCKERGROUPID=$1
ECLIPSEBRANCH=$2
NOCACHE=$3

if [ ! $ECLIPSEBRANCH ]; then
	ECLIPSEBRANCH='master'
fi

echo 
echo "running runAll.sh..."
echo running all using:
echo userName: $USER
echo userId: $USERID
echo dockerGroupId: $DOCKERGROUPID
echo saros-eclipse branch: $ECLIPSEBRANCH


if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipse202412forsaros1
elif [ ! $USERID ]; then
	echo you must specify the userid to be used when building eclipse202412forsaros1, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ] && [ ! -d ./eclipseForSaros ]; then
	echo you must specify the dockergroupid to be used when building eclipse202412forsaros1, use: getent group docker 
else
	if [ ! -d ./eclipse202412forsaros1 ]; then
		./saros-eclipse/buildEclipseForSaros.sh $USER $USERID $DOCKERGROUPID $NOCACHE
		./saros-eclipse/setupDirectoriesAndScriptsForEclipseForSaros.sh $USER
		docker network create eclipseForSarosNet
	fi
	./eclipse202412forsaros1/startEclipseForSarosTempSetup.sh $USER $ECLIPSEBRANCH
fi