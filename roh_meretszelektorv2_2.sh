#!/bin/bash
#This script takes the .roh.hom file from a plink roh output and outputs the IIDs and the homozygous regions that at least a,b, and c lenght long.

#here we set the three tresholds to default
valt1=100000
valt2=250000
valt3=500000
inputfile="none"

#setting variables from options

while [ -n "$1" ]; do 
# while loop starts
 
    case "$1" in
 
    -a) valt1="$2"
	echo "First treshold is set, with the value of $valt1" 
	shift
	;;
    -b) valt2="$2"
        echo "Second treshold is set, with the value of $valt2"
        shift
        ;;
    -c) valt3="$2"
	echo "Third treshold is set, with the value of $valt3"
	shift
	;;
    -in) inputfile="$2"
	shift
 	;;
    -h) echo "Use -a -b and -c to set the three tresholds, and -in, to set the input file. It uses the xyz.roh.hom file as the standard input."
	exit
	shift
	;;
    --)
        shift # The double dash makes them parameters
 
        break
        ;;
 
    *) echo "Option $1 not recognized" ;;
 
    esac
 
    shift
 
done
 


#checking if input file is given

if [ $inputfile == "none" ]
	then
		echo "You have not specified an input file, please use the -in option. Use the -h option for help." 
		exit
	fi

#making a list (not checking it twice)

mylist=`cat $inputfile | awk '{print $2}' | uniq | sed "1 d"`

#making the actual output

for p in $mylist; do
	echo "$p $valt1 $valt2 $valt3"

	for i in $valt1 $valt2 $valt3 
		do
			cat $inputfile | grep $p | awk '{if( $8 - $7 > '"$i"') print $0}' | wc -l | tr "\n" " " 
		done
	echo " "

done


exit
