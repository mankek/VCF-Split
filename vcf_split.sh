#!/bin/bash

usage() {
	echo "Usage: $0 [-h] [c] [-i] [p] [s]"
	echo "	-h	Help."
	echo "	-i	Set multi-sample VCF"
	echo "  -c      Specify variant caller"
	echo "	-p	Print patient names in input file"
	echo "	-s	Perform splitting of input vcf"
	echo "This is a help message"
	exit
}

while getopts "hi:c:sp" optchar;
do
	case $optchar in
		i)
			file="$OPTARG"
			;;
		c)
			caller="$OPTARG"
			;;
		s)
			if test -z "$file"
			then
				echo "No input file!"
				usage
			else
				for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $file)
                        	do
                                	vcftools --vcf $file --indv $f --recode --out $f
                        	done
			fi
                        ;;
		p)
			if test -z "$file"
			then
				echo "No input file!"
				usage
			else
				for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $file)
                        	do
					if test -z "$caller"
					then
                                		echo "$f"
					else
						echo "$f"|awk -F'.' '{ print $2 }'
					fi
                        	done
			fi
                        ;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 1
			;;
		h)
			usage
			;;
	esac
done

