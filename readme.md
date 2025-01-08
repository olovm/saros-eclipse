# saros-eclipse
saros-eclipse is a project to enable easy setup of an Eclipse install for Saros development, using Eclipse and Docker.</br>
I am running this on linux so, change as needed for other platforms.

## Before you begin
1. Make sure you have git and docker set up on your local machine
2. Make a directory where you want everything installed /x/y/z/saros (/mnt/depot/saros)
3. cd to your new directory
3. Clone this repository: `git clone https://github.com/olovm/saros-eclipse.git`



## Installing, runAll
The runAll script will take you through the entire process of setting up a docker based development environment for Saros. It will go through all needed steps. </br>
You can get your docker group id by running;
`getent group docker`

Run:</br>
`./saros-eclipse/runAll.sh dockerGroupId`</br>
**or run:**</br>
`./saros-eclipse/runAll.sh dockerGroupId master nocache`</br>
This option will do a pull of the base image, and not use the cache so that you get the latest version of the packages that gets installed from Fedora.

This scrip will, run the following headers automatically

### Build docker image
Automatically run by runAll<br>
this will take some time as it downloads quite a few things, eclipse, etc

### Create directories on host 
Automatically run by runAll<br>
1. workspace (for your eclipse workspace)
2. eclipse (for your eclipse installation)
3. eclipseP2 (for files shared between multiple installations of eclipse)
4. m2 (for maven files)

### Docker first run installing eclipse
Automatically run by runAll<br>

#### Eclipse installation
When the container starts for the first time will it run the installation part of entrypoint.sh. This will
clone Saros repositories, add other remotes to all of them and start the eclipse installer (oomph). </br>
**There are a few things that needs to be choosen in the installer:**

 1. You need to use the advanced mode 
 
 1. Browse for setup files for eclipse, /home/yourUserName/workspace/saros-eclipse/oomph/EclipseForSaros.setup (use the plussign to add) (use 2022-06)
 2. Java 17+ VM, set it to: /usr/lib/jvm/**java-17-openjdk**
 
 next step
 
 1. In next step browse for setup for projects, /home/yourUserName/workspace/saros-eclipse/oomph/SarosProjects.setup (use the plussign to add)
 2. Make sure "Saros projects" are marked

 next step
 
 1. Choose installation location: "Installed in the specified absolute folder location"
 2. Fill in path for "Root install folder": set it to /home/yourUserName/eclipse
 6. Fill in path for "Installation location": set it to /home/yourUserName/eclipse
 5. Choose Workspace location rule: "Located in the absolute folder location"
 6. Fill in path for "Workspace location": /home/yourUserName/workspace
 7. Fill in path for "JRE 17 Location": /usr/lib/jvm/**java-17-openjdk**
 
 next step
 
 finnish
 
 saros might not allow you to log in, if so, skipp that step and do it later
<br>
This should get you through the installer and will eventually start eclipse and do a first run to setup eclipse. 
You can click on the spinning arrows, in the bottom of the screen to see what the setup does.
<br>
Once the setuptask are finnished, no more spinning arrows, close eclipse, and then close the installer window. 
<br>
You are now ready to do a first startup of the environment. 


## Finishing up, your first startup of the environment

### Setting Gradle version, 
Right click on project saros choose prefrenses / Gradle<br>
set<br>
Specific Gradle version to 7.4.2<br>
java home to /usr/lib/jvm/java-17-openjdk<br>
JVM Arguments<br>
--add-exports jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED<br>
--add-opens java.base/java.util.concurrent=ALL-UNNAMED<br>

## to create new dropin release for eclipse



</br>
Saros not working on later java > 11 </br>
https://github.com/saros-project/saros/issues/1142</br>
https://newbedev.com/how-to-run-eclipse-in-clean-mode-what-happens-if-we-do-so</br>

 docker exec  -it eclipse202412forsaros1 bash</br>
 copy saros.core_0.2.0.jar (fixed one) from </br>
 cp /home/olov/workspace/saros-eclipse/docker/saros.core_0.2.0.jar /home/olov/.p2/pool/plugins/</br>
 nano /home/olov/eclipse/eclipseforsaros/eclipse.ini</br>
  
add </br>
 -clean</br>
to first row</br>
restart eclipse</br>

# Commiting to github using token
## remove password 
 prefrences / security / secure storage / contents
 
remove git from default secure storage

## generate a github token
as described here:

https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token

## push to git with token
username: your normal username
password: your token


### For adding marketplace to oomph installer (note to self)
https://stackoverflow.com/questions/47582157/eclipse-marketplace-plug-ins-silent-install
Given a Marketplace install URL (https://marketplace.eclipse.org/marketplace-client-intro?mpc_install={ID}), construct the API URL as https://marketplace.eclipse.org/node/{ID}/api/p. Retrieve the XML file from that URL and look for the repository URL in the updateURL tag, and the available features in the ius tag. You'll need to append .feature.group to each IU feature listed


# Gradle
## Note to self..
enter docker:
docker exec -it eclipse202412forsaros1 bash

cd /home/yourUserName/workspace/saros

show project structure:

./gradlew -q projects

./gradlew :saros.core:tasks

./gradlew :saros.core:clean

./gradlew :saros.core:build

when you have updated dependencies to get them into eclipse, run this again, and refresh project
./gradlew prepareEclipse


