#!/bin/bash
RACCOON="/raccoon"
FDROID="/fdroid"

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

function moveAPK {
	input="$1"
	output="$2"
	if [ ! -f $output ]
	then
		cp -f $input $output
	fi
}


function moveRecursive {
	for item in `ls "$1"` ; do
		if [ -d "$1" ]
		then
			file="$1/$item"
		else
			file="$item"
		fi

		if [ -d "$file" ]
		then
  			moveRecursive "$file"
		else
			FILEEXT=${file##*.}
			FILENAME=`basename "$file"`
			FILENAME=${FILENAME%.*}
			FILEPATH=`/usr/bin/dirname "$file"`
			if [ $FILEEXT == "apk" ]
			then
				moveAPK "$FILEPATH/$FILENAME.$FILEEXT" "$FDROID/repo/$FILENAME.apk"
			fi
		fi
	done
}

#check if there is something to import
echo "### importing new Apps to RACCOON..."
if [ -s "/import.txt" ]
then
	java -jar /bin/raccoon.jar -a $RACCOON -i /import.txt
	echo "" > /import.txt
else
	echo "nothing to import"
fi
echo "### updating RACCOON Apps..."
java -jar /bin/raccoon.jar -a $RACCOON -u

#check if config is available
if [ ! -f "$FDROID/config.py" ]
then
	echo "### initializing new FDROID Repository..."
	cd $FDROID
  fdroid init
fi

# Link all APKs to FDroid Repo
echo "### link Apps from RACCOON to FDROID..."
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
moveRecursive $RACCOON
IFS=$SAVEIFS

cd $FDROID
# Update Fdroid and create Metadata if needed
echo "### updating FDROID..."
fdroid update -c
