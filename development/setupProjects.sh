#! /bin/bash

workspaceDir=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)

start(){
	setUser;
	chooseRepo;
	importProjectListing;
	preventGitAskingForUsernameAndPasswordIfRepoIsMissing;
	addAllRepositories;
}

setUser(){
	if [ -z ${USER+x} ]; then 
		echo "USER is unset"; 
	else 
		echo "USER is set to '$USER'"; 
		user=$USER
		export user
	fi
}

chooseRepo(){
	echo ""
	echo "Please choose the remote you want to use as origin or enter a different one, "
	echo "where the saros projects have been cloned."
	echo "1. https://github.com/saros-project/"
	echo "2. https://github.com/olovm/"
	echo "Choose 1, 2 or enter your own base url to clone as origin. (eg. https://github.com/olovm/)"
	read -p "For origin, use? " userchoice
	case "$userchoice" in
	        1)
				echo "You choose: $userchoice 1"
	            originRepo="https://github.com/saros-project/"
	            otherRepos="olovm"
	            ;;
	        2)
				echo "You choose: $userchoice 2"
	            originRepo="https://github.com/olovm/"
	            otherRepos="saros-project"
	            ;;
	        *)
				echo "You choose: $userchoice other"
	            originRepo="$userchoice"
	            otherRepos="saros-project olovm"
	esac
	
	echo "Origin choosen as: $originRepo"
	echo "Others remotes will be: $otherRepos"
}

importProjectListing() {
	.  $BASEDIR/projectListing.sh
}

preventGitAskingForUsernameAndPasswordIfRepoIsMissing() {
	#export GIT_ASKPASS="/bin/true"
	export GIT_TERMINAL_PROMPT=0
	unset SSH_ASKPASS
}

addAllRepositories() {
    N=10;
	for PROJECT in $ALL; do
		((i=i%N)); ((i++==0)) && wait
		cloneRepoAndAddRemotes $PROJECT &
	done
        wait      # catch the processes that we did not wait for earlier
}

cloneRepoAndAddRemotes() {
	local projectName=$1
	 
	echo " "
	echo "..."
	echo "checking that repository and project exists:"
	setWorkingRepositoryAndProjectNameAsTemp
	echo "..."
	echo " "
	echo "clone using:"
	echo "tempRepository: $tempRepository"
	echo "tempProjectName: $tempProjectName"
	
	cd $workspaceDir
	git clone $tempRepository$tempProjectName.git $projectName
	cd $workspaceDir/$projectName
	addOtherRemotes $projectName
	#git fetch --all
	cd $workspaceDir
}

setWorkingRepositoryAndProjectNameAsTemp(){
	tempProjectName=$projectName
	tempRepository=$originRepo

	if ! checkIfTempUrlExists; then 
		echo "- WARN - Chosen origin not found ($tempRepository$tempProjectName)"
		tryWithProjectNameWithoutCora
	fi
}

checkIfTempUrlExists(){
	local status=$(lookupUrl $tempRepository$tempProjectName)
	if [  $status -eq 200 ]; then 
		return 0
	fi
	echo "- WARN - Status for: $tempRepository$tempProjectName: $status"
	echo "Trying one more time..."
	
	local status=$(lookupUrl $tempRepository$tempProjectName)
	if [  $status -eq 200 ]; then 
		return 0
	fi
	false
}

lookupUrl(){
	local url=$1
	local status=$(curl -s --head -w %{http_code} $url --connect-timeout 10 -o /dev/null)
	echo $status
}

tryWithProjectNameWithoutCora(){
	ensureTempProjectNameDoesNotHaveCora
	
	if ! checkIfTempUrlExists; then 
		useSarosProjectAsOrigin
	fi
	
	if ! checkIfTempUrlExists; then 
		useOlovmAsOrigin
	fi
}

ensureTempProjectNameDoesNotHaveCora(){
	echo "Trying project name without cora..."
	if [ ${projectName:0:4} = "cora" ]; then
		tempProjectName=${projectName:5}
	#else
	fi
}

useSarosProjectAsOrigin(){
	echo "- WARN - Falling back to using saros-project as origin";
	tempProjectName=$projectName
	tempRepository="https://github.com/saros-project/"

	if ! checkIfTempUrlExists; then
		ensureTempProjectNameDoesNotHaveCora
	fi
}

useOlovmAsOrigin(){
	echo "- WARN - Falling back to using olovm as origin";
	tempProjectName=$projectName
	tempRepository="https://github.com/olovm/"

	if ! checkIfTempUrlExists; then
		ensureTempProjectNameDoesNotHaveCora
	fi
}

addOtherRemotes(){
	local projectName=$1
	for otherRepoName in $otherRepos; do
		#echo "git remote add github-$otherRepoName https://github.com/$otherRepoName/$projectName.git"
		git remote add github-$otherRepoName https://github.com/$otherRepoName/$projectName.git
	done
}
	

# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
