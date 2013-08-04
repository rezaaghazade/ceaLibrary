#!/bin/bash - 
#          FILE: ceaLibrary.sh
#         USAGE: ./ceaLibrary.sh 
#   DESCRIPTION: 
#  REQUIREMENTS: kernel >  2.6.0 , bash > 4.2.0
#         NOTES: read it,learn it,share it
#        AUTHOR: |reza.aghazade|  ,  |reza.zah1991@gmail.com|
#  ORGANIZATION: |mine OpenSource Co.|
#       CREATED: 07/28/2013 01:10:39 PM IRDT
#===============================================================================

SQLITEPATH='/usr/bin/sqlite'
DATABASENAME='ceaSTU2.db'
CREATESQL='CREATE TABLE STU(ID INTEGER PRIMARY KEY,NAME VARCHAR(30),FAMILY VARCHAR(40),FIELD VARCHAR(50),PHONE INT,MAIL VARCHAR(70),SEX VARCHAR(1),DEL INTEGER);'
SQLITEPATH='/usr/bin/sqlite'
STUDENTRECORD=""
_check=1

#trap '' SIGINT    # trap ^C Signal
clear
if [ ! -e $SQLITEPATH ]
then
	echo "Sqlite Is not Exist"
	exit 1
fi
if [ ! -e $DATABASENAME ]
then
	echo $CREATESQL | sqlite $DATABASENAME
fi

insertFrameShow ()
{
	clear
        echo "Each Student Need Below Requrement : (* is Necessary)"
        echo "STU ID(*),STU Name(*),STU Family(*),STU Field,STU Phone(*),STU e-Mail() "
        echo -e "---------------------------------------------------------------------\n"
}	# ----------  end of function insertFrameShow  ----------
insert ()
{
	insertFrameShow
	FIRST=0
	CONDITION=true
	ANS=""
	while [  $CONDITION=="true" ]
	do	
		_check=0
		read -p "Enter STU ID : " ID
		read -p "Enter STU Name : " NAME
		read -p "Enter STU Family : " FAMILY
		read -p "Enter STU Field : " FIELD
		read -p "Enter STU Phone : " PHONE
		read -p "Enter STU e-Mail : " EMAIL
		read -p "Enter SEX : " SEX
		FIRST=1
		check 1 $ID $NAME $FAMILY $PHONE $EMAIL	$SEX
		if [ $_check -eq 0 ]
		then
			echo "INSERT INTO STU VALUES('$ID','$NAME','$FAMILY','$FIELD','$PHONE','$EMAIL','$SEX','0');"|sqlite $DATABASENAME
			if [ $? -eq 0 ]
			then
				echo "Insert COmplete"				
				sleep 1							
			fi
		fi
<<comment
		if [ ! $FIRST -eq 0 ]
                then
                        read -p "Do You Want to Add Another Person ? (y/n)" ans
			echo $ans
                        if [ $ans=="y" ]
                        then
	                           echo "in if"     
                        elif [ $ans=="n" ]
			then
				echo "in else"
                                CONDITION="false"
                                clear                               
                        fi
                fi
comment
	done
	
	
	
}	# ----------  end of function insert  ----------


check ()
{
	INSIDECHECK=0
	_check=0
	#check 1 $ID $NAME $FAMILY $PHONE $EMAIL
	# 1st Arguman is define which FUNC call it
	if [ $1 -eq 1 ]
	then
		ALNUMLENGHT=${#2}
                DIGIT=`echo $2|sed 's/[^0-9]//g'`
                DIGITLENGHT=${#DIGIT}
                if [  $ALNUMLENGHT -ne 8  -o  $ALNUMLENGHT -ne $DIGITLENGHT ] 
                then
                        echo "STU ID is Not Correct Style( 8digit,Without Alphabet)"
			INSIDECHECK=1
                        _check=6
                fi

		tt=`echo "SELECT * FROM STU WHERE ID=$2;"|sqlite $DATABASENAME|wc -l`		
		if [ $tt -ne 0 -a $INSIDECHECK -ne 1 ]
		then
			_check=1
			echo "Duplicate STU ID"
		fi
		if [ -z $3 ]
		then
			_check=2
			echo "Empty name"
		fi
		if [ -z $4 ]
		then
			_check=3
			echo "Empty Family"
		fi
		if [ ! $7=="f" -o !$7=="m" ]
		then
			_check=4
			echo "Unkown SEX"
		fi
<<comm
		PHONECODE=${5:0:3}
		if [ [ ! $PHONECODE -eq 091 ] -o [ ! $PHONECODE -eq 093 ] ]
		then
			_check=4
			echo "Wrong Phone Num"
			return
		fi
		ENDOFMAIL=${6#*@}
		echo $ENDOFMAIL
		if [[! $ENDOFMAIL=="gmail.com"] -o [! $ENDOFMAIL=="yahoo.com"] -o [! $ENDOFMAIL=="ymail.com"] -o [! $ENDOFMAIL=="hotmail.com"] -o [! $ENDOFMAIL=="msn.com"]]
		then
			echo "Unknown Email Provider"
			_check=5
			return
		fi
comm
	fi	
	
}	# ----------  end of function check  ----------

showlist ()
{
	
	clear
	echo "STUDENT Database Content"
	echo "------------------------"
	cat sqlite.cnf|sqlite $DATABASENAME|more
	echo -e "-----------------------------------------------------------------------------------------------------------\n"
	
}	# ----------  end of function showlist  ----------

searchStudent ()
{
	STUID=$1
	STUDENTRECORD=`echo "SELECT * FROM STU WHERE ID=$STUID;"|sqlite $DATABASENAME`
	
}	# ----------  end of function searchStudent  ----------
modifyStudent ()
{
	clear
	echo "Modify SignIn Student "
	echo "-----------------------------------------------------------------"
	read -p "Enter STU Number : " STUID
	searchStudent $STUID
	if [ -n STUDENTRECORD ]
	then
		echo "Student Found"
		echo "----------------------------------------------------------------"
		echo "SELECT ID,NAME,FAMILY,FIELD,PHONE,MAIL,SEX FROM STU WHERE ID=$STUID;">>sqlite2.cnf
		echo ".exit">>sqlite2.cnf
		cat sqlite2.cnf|sqlite $DATABASENAME
		echo ""
	else
		echo 	"Student Not Found"
	fi
	
}	# ----------  end of function modifyStudent  ----------
show ()
{
	echo "Computer Engeenring Assosiation Student List : "
	echo -e "------------------------------------------------\n"
	echo "Operation is : "
	echo "1) Insert Student	3) Modify Student	5) Clear Screen"
	echo "2) Delete Student	4) List SignIn Student  6) Exit"
}

echo -e "Computer Engeenring Assosiation Student List : "
echo -e "------------------------------------------------\n"
echo "Operation is : "
select choice in 'Insert Student' 'Delete Student' 'Modify Student' 'List SignIn Student' 'Clear Screen' 'Exit'
do
	case $choice in
		'Insert Student')
			insert
			show
		;;
		'Delete Student')
			show
		;;
		'Modify Student')
			modifyStudent
			show
		;;
		'List SignIn Student')
			showlist
			show
		;;
		'Clear Screen')
			clear
			show
		;;
		'Exit')
			echo "GoodBye"
			exit 0
		;;
	esac

done

