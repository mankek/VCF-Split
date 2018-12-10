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
			;;
	esac
done

