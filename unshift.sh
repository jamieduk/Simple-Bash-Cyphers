#!/bin/bash
# (c) J~Net 2021
# jnet.sytes.net
#
# https://jnet.forumotion.com/t1731-custom-shift-cypher-generator#2680
#
# ./unshift.sh "mjqqt" "5"
#
# P.S you will need figlet installed for full experience!
#
red=`tput setaf 1`
green=`tput setaf 2`
bluealt=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`
echo -e "${green}Welcome To Custom UnShift Cypher By"
echo -e "${blue}"
echo "(c)J~Net 2021" | figlet
#
if [ -z "$1" ]
then
  read -p "Enter Phrase : " phrase
  else
  phrase=$1
fi
#
# Convert upper case to lower!
val=$(echo "$phrase" | tr '[:upper:]' '[:lower:]') # You can reverse this and make it all upper case!
phrase=$val
#
if [ -z "$2" ]
then
  read -p "Enter Number To Rotate By (Less than 26) For Example Key E=4: " rotat
else
  rotat=$2
fi
#
#rotat=$rotat-1
undo=$((26 - $rotat))
Frotat=$((rotat - 1))
#
dual="abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
# The next two lines have been commented out but could be hardcoded!
#phrase='hello there'
#rotat=13
newphrase=$(echo $phrase | tr "${dual:0:26}" "${dual:${undo}:26}") #Frotate also could be used!
#
echo -e "${blue}"
echo "Cypher With Shift Of $rotat With (Undo Shift Rotation : $undo)"
# Show key shift to reverse this generator 26- the key = the reverse shift key)

echo ""
echo ${newphrase}
