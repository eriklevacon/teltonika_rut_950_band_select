#!/bin/sh

#set -x ##Activation mode verbeux pour debug
## manque les fonctions pour forcer le modem huawei en 3G (WIP !!)

verifier_input() {

	if [ $# -eq 2 ] 
		then
			echo "il y a $# paramtres"
			MODE=$1			
			FREQUENCE=$2
		else
			echo "il y a $# paramtres"			
			echo "Usage: setfrequency <mode> [LTE] (obligatoire) <frequence> [800|1800|2100|2600|ALL]"
		exit 255
	### Reste a developper la partie mode et frequence pour le 3G
	fi

}

reset_interface() {

	ifdown ppp
	sleep 10
	ifup ppp

}

set1800() {
	setmode "000000000000004" ##1800Mhz
}

set2100() {
	setmode "000000000000001" ##2100MHz
}

set2600() {
	setmode "000000000000040" ##2600MHz
}

set800() {
	setmode "000000000080000" ##800MHz
}

setallfreq() {

	setmode "FFFFFFFFFFFFFFF" ##Toutes frequences LTE (mode par defaut usine)
}



setmode() {
	PARAM=$1
	gsmctl -A "AT^SYSCFGEX=\"03\",3FFFFFFF,1,2,$PARAM,,"
}

################################  main  ################################

verifier_input $1 $2
echo "MODE: $MODE"
reset_interface



# fixation du paramètre

if [ "$MODE" = "LTE" ]
	then


	case $FREQUENCE in
		800)
		  echo "Reglage du modem sur LTE-800."
		  set800
	  ;;
		1800)
		  echo "Reglage du modem sur LTE-1800."
		  set1800
	  ;;
		2100)
		  echo "Reglage du modem sur LTE-2100."
	  	  set2100
	  ;;
		2600)
		  echo "Reglage du modem sur LTE-2600."
	  	  set2600
	  ;;
		ALL)
		  echo "Reglage du modem sur LTE-2600."
	  	  setallfreq
	  ;;
		*)
		  echo "Paramètre Fréquence Inconnu."
		exit 255
	  ;;
	esac

fi

echo "Terminé"

exit 0





