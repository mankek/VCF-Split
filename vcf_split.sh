#!/bin/bash

usage() {
	echo "Usage: $0 [-h] [-i] [p] [s]"
	echo "	-h	Help."
	echo "	-i	Set multi-sample VCF"
	echo "	-p	Print patient names in input file"
	echo "	-s	Perform splitting of input vcf"
	echo "This is a help message"
	exit
}

while getopts "hi:sp" optchar;
do
	case $optchar in
		i)
			file="$OPTARG"
			;;
		s)
			for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $file)
                        do
                                vcftools --vcf $file --indv $f --recode --out $f
                        done
                        ;;
		p)
			for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $file)
                        do
                                echo "$f"
                        done
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

