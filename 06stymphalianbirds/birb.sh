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