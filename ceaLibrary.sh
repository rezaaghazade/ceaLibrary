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
}	# ----------  end of function insert  ----------
echo "Qom University Of TEchnology Computer Engeenring Assosiation Student List : "
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
