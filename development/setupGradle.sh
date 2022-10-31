#! /bin/bash

workspaceDir=~/workspace
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)

start(){
	runGradlew;
}

runGradlew() {
	echo " "
	echo "Trying to run gradlew:"
	echo " "
	cd $workspaceDir/saros
	./gradlew prepareEclipse
	cd ~
}

# ################# calls start here #######################################
start
