#! /bin/bash

echo "Running setupDirectoriesAndScriptsForEclipseForSaros..."

USER=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
PARENTDIR="$(dirname "$BASEDIR")"
INSTALLDIR=$PARENTDIR/eclipse202209forsaros1
TOPDIR="$(dirname "$PARENTDIR")"

echo 
echo script: $SCRIPT
echo basedir: $BASEDIR
echo parentdir: $PARENTDIR
echo installdir: $INSTALLDIR

createDirectories(){
  	mkdir $INSTALLDIR
  	mkdir $INSTALLDIR/eclipse
  	mkdir $INSTALLDIR/.eclipse
  	mkdir $INSTALLDIR/.saros
  	mkdir $INSTALLDIR/workspace
 	mkdir $PARENTDIR/m2
  	mkdir $PARENTDIR/eclipseP2
  	mkdir $PARENTDIR/sharedArchive
  	mkdir $PARENTDIR/sharedArchive/systemOne
  	mkdir $PARENTDIR/sharedArchive/alvin
  	mkdir $PARENTDIR/sharedArchive/diva
}
	
changeAndCopyScripts(){
	cp $BASEDIR/startEclipseForSaros.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startEclipseForSaros.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startEclipseForSaros.sh

	cp $BASEDIR/startEclipseForSarosTempSetup.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startEclipseForSarosTempSetup.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startEclipseForSarosTempSetup.sh

	cp $BASEDIR/startEclipseForSarosNoPorts.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startEclipseForSarosNoPorts.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startEclipseForSarosNoPorts.sh
	
	cp $BASEDIR/development/projectListing.sh $INSTALLDIR/projectListing.sh
	cp $BASEDIR/development/setupProjects.sh $INSTALLDIR/setupProjects.sh
	
	cp $BASEDIR/docker/docker-compose.yml $INSTALLDIR/
	cp $BASEDIR/docker/Dockerfile $INSTALLDIR/
	cp $BASEDIR/docker/entrypoint.sh $INSTALLDIR/
	
	cp $BASEDIR/docker/derived $INSTALLDIR/workspace/.derived
}

createGitConfigFile(){
	touch $PARENTDIR/.gitconfig
}

createArchiveReadableFile(){
	rm $PARENTDIR/archiveReadable
	touch $PARENTDIR/archiveReadable.sh
	echo "docker exec -u 0 eclipse202209forsaros1 bindfs --map=root/$USER:@root/@$USER /tmp/sharedArchive/ /tmp/sharedArchiveReadable/" > $PARENTDIR/archiveReadable.sh
	chmod +x $PARENTDIR/archiveReadable.sh
}

if [ ! -d $INSTALLDIR ]; then
	createDirectories
	changeAndCopyScripts
	createGitConfigFile
	createArchiveReadableFile
fi
