#!/bin/bash


while getopts ":i:" optchar;
do
	case $optchar in
		i)
			for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $OPTARG)
			do
				vcftools --vcf $OPTARG --indv $f --recode --out $f
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
	esac
done

