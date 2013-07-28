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
DATABASENAME='ceaSTU.db'
CREATESQL='CREATE TABLE STU(ID INTEGER PRIMARY KEY,NAME VARCHAR(30),FAMILY VARCHAR(40),FIELD VARCHAR(50),PHONE INT,MAIL VARCHAR(70));'
#INSERTSQL='INSERT INTO STU VALUES (,'GHOLI','ASD','ASDASD',0912387,'REZA.ZAH1991');'
SQLITEPATH='/usr/bin/sqlite'
_check=1


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

insert ()
{
	clear
	echo "Each Student Need Below Requrement : (* is Necessary)"
	echo "STU ID(*),STU Name(*),STU Family(*),STU Field,STU Phone(*),STU e-Mail() "
	echo -e "---------------------------------------------------------------------\n"
	FIRST=0
	condition=true
	while [  $condition=="true" ]
	do	
		if [ $FIRST -ne 0 ]
		then
			read -p "Do You WAnt To Cancel This OP (y/n)" ans
			if [ $ans=="y" ]
			then
				echo "OP Canceled"
				return
			fi
		fi
		_check=0
		read -p "Enter STU ID : " ID
		read -p "Enter STU Name : " NAME
		read -p "Enter STU Family : " FAMILY
		read -p "Enter STU Field : " FIELD
		read -p "Enter STU Phone : " PHONE
		read -p "Enter STU e-Mail : " EMAIL
		FIRST=1
		check 1 $ID $NAME $FAMILY $PHONE $EMAIL	
		if [ $_check -eq 0 ]
		then
			condition=false
			echo "INSERT INTO STU VALUES('$ID','$NAME','$FAMILY','$FIELD','$PHONE','$EMAIL');"|sqlite $DATABASENAME
			if [ $? -eq 0 ]
			then
				echo "Insert COmplete"				
			fi
			break
		fi
	done
	
	
	
}	# ----------  end of function insert  ----------


check ()
{
	# 1st Arguman is define which FUNC call it
	if [ $1 -eq 1 ]
	then
		tt=`echo "SELECT * FROM STU WHERE ID=$2;"|sqlite $DATABASENAME|wc -l`
		if [ $tt -ne 0 ]
		then
			_check=1
			echo "Duplicate STU ID"
			return
		fi
		if [ -z $3 ]
		then
			_check=2
			echo "Empty name"
			return
		fi
		if [ -z $4 ]
		then
			_check=3
			echo "Empty Family"
			return
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
	else
		_check=0
	fi
	
	
}	# ----------  end of function check  ----------


echo "Computer Engeenring Assosiation Student List : "
echo -e "------------------------------------------------\n"
select choice in 'Insert Student' 'Delete Student' 'Modify Student' 'Exit'
do
	case $choice in
		'Insert Student')
		insert
		;;
		'Delete Student')
		;;
		'Modify Student')
		;;
		'Exit')
		echo "GoodBye"
		exit 0
		;;
	esac

done

