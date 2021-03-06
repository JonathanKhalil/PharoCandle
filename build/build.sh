#!/bin/bash
set -e

#Setup arguments
RESULTS_FOLDER="results"
if [ $# == 0 ]; then
	VERSION=bleedingEdge
else
	VERSION=$1
fi


#Work in temporal directory
if [ -a $RESULTS_FOLDER ]; then
		echo "cannot create directory named \""$RESULTS_FOLDER"\": file already exists"
		exit 1
fi

mkdir $RESULTS_FOLDER
cd $RESULTS_FOLDER

#Load image for this project

wget -O - guillep.github.io/files/get/OzVmLatest | bash
wget -O - get.pharo.org/30 | bash
wget http://files.pharo.org/sources/PharoV30.sources
./oz Pharo.image save PharoCandleBootstrap --delete-old



#Load stable version of the monticello configuration, according to this git sources
REPO=http://smalltalkhub.com/mc/Guille/Seed/main
./oz PharoCandleBootstrap.image config $REPO ConfigurationOfHazelnut --install=$VERSION

echo "Configuration Loaded. Opening script..."

echo -e "
Workspace openContents: 'objectSpace := PharoCandleBuilder2 bootstrap: ''../source''.
objectSpace serializeInFileNamed: ''PharoCandle.image''.'.
Smalltalk snapshot: true andQuit: true." > ./script.st

./oz PharoCandleBootstrap.image script.st
rm script.st
rm PharoDebug.log
echo "Script created and loaded. Finished! :D"
