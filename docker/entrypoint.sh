#! /bin/bash
ECLIPSEBRANCH=$eclipsebranch
echo "running entrypoint.sh..."
echo "*** using saros-eclipse branch: $ECLIPSEBRANCH ***"

firstRun(){
	git clone https://github.com/olovm/saros-eclipse.git ~/workspace/saros-eclipse
	if [ $ECLIPSEBRANCH != 'master' ]; then
		echo "*** checking out saros-eclipse branch: $ECLIPSEBRANCH ***"
		cd ~/workspace/saros-eclipse
		git checkout $ECLIPSEBRANCH
		cd ~
	fi
		
	chmod +x ~/workspace/saros-eclipse/development/setupProjects.sh
	~/workspace/saros-eclipse/development/setupProjects.sh ~/workspace
	
	chmod +x ~/workspace/saros-eclipse/development/setupGradle.sh
	~/workspace/saros-eclipse/development/setupGradle.sh
	
	runInstaller	
	
	chmod +x ~/workspace/saros-eclipse/development/postInstaller.sh
	~/workspace/saros-eclipse/development/postInstaller.sh ~/workspace
}

runInstaller(){
	~/eclipse-installer/eclipse-inst
}

if [ ! -d ~/workspace/saros-eclipse ]; then
  	firstRun
elif [ ! -d ~/eclipse/eclipseforsaros ]; then
	runInstaller
else
	~/eclipse/eclipseforsaros/eclipse
fi