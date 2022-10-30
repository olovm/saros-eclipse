#! /bin/bash

workspaceDir=~/workspace
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)

start(){
	addAllRepositories;
}

runGradlew() {
	echo " "
	echo "Trying to run gradlew:"
	echo " "
	echo "clone using:"
	echo "tempRepository: $tempRepository"
	echo "tempProjectName: $tempProjectName"
	
	cd $workspaceDir
	gradlew prepareEclipse
	cd ~
}

# ################# calls start here #######################################
start
