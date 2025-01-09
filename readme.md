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

You need to use the advanced mode 
 
1. Browse for setup files for eclipse, /home/yourUserName/workspace/saros-eclipse/oomph/EclipseForSaros.setup (use the plussign to add) 
2. use version 2024-12
3. Java 21+ VM, set it to: /usr/lib/jvm/**java-23-openjdk**
 
next step

1. In next step browse for setup for projects, /home/yourUserName/workspace/saros-eclipse/oomph/SarosProjects.setup (use the plussign to add)
2. Make sure "Saros projects" are marked

 next step
 
 1. Choose installation location: "Installed in the specified absolute folder location"
 2. Fill in path for "Root install folder": set it to `/home/yourUserName/eclipse`
 6. Fill in path for "Installation location": set it to `/home/yourUserName/eclipse`
 5. Choose Workspace location rule: "Located in the absolute folder location"
 6. Fill in path for "Workspace location": `/home/yourUserName/workspace`
 
 next step
 
 finnish
 
<br>
This should get you through the installer and will eventually start eclipse and do a first run to setup eclipse. 
You can click on the spinning arrows, in the bottom of the screen to see what the setup does.
<br>
Once the setuptask are finnished, no more spinning arrows, close eclipse, and then close the installer window. 
<br>
You are now ready to do a first startup of the environment. 


## Finishing up, your first startup of the environment
Run:</br>
`./eclipse202412forsaros1/startEclipseForSaros.sh`</br>

### Open Gradle Tasks view
open Gradle Tasks view, `Ctrl + 3` choose Gradle Tasks<br>
choose to import project<br>
choose `/home/yourUserName/workspace/saros`<br>
next<br>
Override workspace settings use:<br>
Specific Gradle version to 7.4.2<br>
java home to `/usr/lib/jvm/java-17-openjdk`<br>
JVM Arguments<br>
--add-exports jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED<br>
--add-opens java.base/java.util.concurrent=ALL-UNNAMED<br>

(you might have to restart eclipse to get all changes)

If there are problems or when dependencies are changed:<br>
enter the running docker, in a console:<br>
`docker exec -it eclipse202412forsaros1 bash` <br>
`cd /home/yourUserName/workspace/saros` <br>
`./gradlew prepareEclipse` <br>

refresh saros project in eclipse

## to create new dropin release for eclipse
create a new Feature project by<br>
File/New/Other...<br>
Plug-in Development/Feature Project<br>
Project name: saros_dropin<br>
Finish (don't open the perspective)<br>

copy files from saros/eclipse/feature (build.properties, feature.xml)<br>
to the new project saros_dropin (replace the created files)<br>

### create the dropin<br>
File/Export...<br>
Plug-in Development/Deployable features<br>
choose saros.feature(17.0.0)<br>
choose output directory `saros_dropin/dropin`(create the folder)<br>
finish<br>

if you get an error message and in the log find something similar to this:<br>
\# Eclipse Compiler for Java(TM) v20241112-0530, 3.40.0, Copyright IBM Corp 2000, 2020. All rights reserved.
Compliance level '17' is incompatible with target level '23'. A compliance level '23' or better is required

change <br>
Window/Prefrences/Java/Compiler<br>
Compiler compliance level: to 17<br>

Create the export again so that you do not get any errors reported.

### Install Saros in other Eclipse
you can now copy the folders plugins and features from saros_dropin/dropin (the output folder from above)<br>
to an eclipse/dropins/ folder and restart that eclipse to get Saros running

# Note to self..
## Commiting to github using token
### remove password 
 prefrences / security / secure storage / contents
 
remove git from default secure storage

### generate a github token
as described here:

https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token

### push to git with token
username: your normal username
password: your token


#### For adding marketplace to oomph installer (note to self)
https://stackoverflow.com/questions/47582157/eclipse-marketplace-plug-ins-silent-install
Given a Marketplace install URL (https://marketplace.eclipse.org/marketplace-client-intro?mpc_install={ID}), construct the API URL as https://marketplace.eclipse.org/node/{ID}/api/p. Retrieve the XML file from that URL and look for the repository URL in the updateURL tag, and the available features in the ius tag. You'll need to append .feature.group to each IU feature listed


## Gradle

enter docker:
`docker exec -it eclipse202412forsaros1 bash`

`cd /home/yourUserName/workspace/saros`

`./gradlew --version`

show project structure:<br>
`./gradlew -q projects`

`./gradlew :saros.core:tasks`

`./gradlew :saros.core:clean`

`./gradlew :saros.core:build`


when you have updated dependencies to get them into eclipse, run this again, and refresh project<br>
`./gradlew prepareEclipse`


