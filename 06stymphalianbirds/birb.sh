#!/bin/sh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPTPATH="$( readlink $SCRIPTPATH/$0)"
SCRIPTPATH="$( cd "$(dirname "$SCRIPTPATH")" ; pwd -P )"

GIT=.git # something something directory settings

Bl="\[\033[0;30m\]"	# Black
R="\[\033[0;31m\]"	# Red
G="\[\033[0;32m\]"	# Green
Y="\[\033[0;33m\]"	# Yellow
B="\[\033[0;34m\]"	# Blue
P="\[\033[0;35m\]"	# Purple
C="\[\033[0;36m\]"	# Cyan
W="\[\033[0;37m\]"	# White

#Error Message
#error <text>

error () {
	echo "${R}Error: $1${N}"
}

#Make Directory
#make_dir <dir_name>

make_dir () {
	if [ -z $1 ] ; then
		error "Need a name for ${C}make_dir()"
		return 1
	fi
	echo "${W}Creating directory ${C}$1"
	mkdir -p $1
}

#Meat and potatoes
echo "${W}What is the name of the project?"
read NAME

if [ -z "$NAME" ] ; then
	error "The project needs a name, you goon."
	exit
fi
if [ -d $NAME ] ; then
	error "Directory ${C}$NAME${R} already exists."
	exit
fi
if [ -f $NAME ] ; then
	error "File ${P}$NAME${R} already exists."
	exit
fi

echo "${W}Initializing git repository."
git init $NAME >> /dev/null

cd $NAME
echo "cd into repo..."

echo "${B}Option:Set up remote repository?$N"
REMOTE="origin"
while [ ! -z $REMOTE ] ; do
	echo "${P} Remote ${W}name?$W"
	echo "${B}(Press enter to skip...)$N"
	read REMOTE
	if [ ! -z $REMOTE ] ; then
		echo "${W}What is the ${P}remote URL$W?"
		read URL
		if [ ! -z $URL ] ; then
			git remote rm $REMOTE &> /dev/null
			echo "${B}Adding remote ${C}$REMOTE${B} at ${P}$URL${B}"
			git remote add $REMOTE $URL
			if [ "$?" -eq 1 ] ; then
				error "Invalid repository. Deleting remote $C$REMOTE$R."
				git remote rm $REMOTE
			else
				git pull $REMOTE master &> /dev/null
			fi
		else
			echo "${R}No remote added for ${P}$REMOTE$R.$N"
		fi
	fi
done


if [ ! -z $GIT_DIR ] ; then
		GIT=$GIT_DIR
	fi
	echo "*.swp" >> $GIT/info/exclude
	echo ".*.swp" >> $GIT/info/exclude

	# Project typing
	echo "${W}What kind of project is ${P}$NAME${W} going to be?"
	echo "${B}(For example: ${C}c$B, ${C}py$B, ${C}sh$B...)$N"
	read TYPE

if [ ! -z $TYPE ] ; then
	if [ -f $SCRIPTPATH/.init.$TYPE.sh ] ; then
		echo "${B}Starting a new ${C}$TYPE$B project...$N"
		sh $SCRIPTPATH/.init.$TYPE.sh "$NAME" "$GIT"
	else
		echo "${R}No project type
		${C}$TYPE$R found.$N"
	fi
else
	echo "${B}Skipping...$N"
fi

echo "${B}Adding files to git and making first commit.${W}"
git add .
git status
git commit -m "Initial commit"
echo "${G}Done.${N}"
