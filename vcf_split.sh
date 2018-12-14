#!/bin/bash
usage() {
	echo "Usage: $0 [-h] [-i FILE] [-o OUTPUT] [-c CALLER] [-r] [-p] [-s]"
	echo "	-h	Displays this help message."
	echo "	-i	Multi-sample VCF location; required."
	echo "	-o	Split VCF file output location; each individual vcf will be sent to the same location, but will automatically be named by patient name."
	echo "  -c      Specify variant caller; optional for either printing or splitting."
	echo "	-p	Print patient names in input file. Setting the -c argument will print all patient names with the specified caller."
	echo "	-r	If -c option is set, remove log files for non-selected samples"
	echo "	-s	Perform splitting of input vcf. Setting the -c argument will split out the patients with the specified caller."
	echo "This is a help message."
	exit
}

location() {
	if test -z "$output"
	then
		echo "$1"
	else
		loc=$output
		echo "$loc/$1"
	fi
}

remove() {
	if test -z "$caller"
	then
		echo "No unselected samples"
	else
		for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $file)
		do
			no_pat=$(echo "$f"|awk -F'.' -v pat="$caller" '{ if ($2 != pat) print $1 "." $2".log" }')
			if test -n "$no_pat"
			then
				rm "$no_pat"
			fi
		done
	fi
}

while getopts "i:o:c:sprh" optchar;
do
	case $optchar in
		i)
			file="$OPTARG"
			;;
		o)
			output="$OPTARG"
			;;
		c)
			caller="$OPTARG"
			;;
		r)
			rm_flag="True"
			;;
		s)
			if test -z "$file"
			then
				echo "No input file!"
				usage
			else
				for f in $(awk '/^#CHROM/ {for (i=10; i<=NF; i++) print $i; }' $file)
                        	do
					out=$(location $f)
					if test -z "$caller"
					then
                                		vcftools --vcf $file --indv $f --recode --out $out
					else
						patient=$(echo "$f"|awk -F'.' -v pat="$caller" '{ if ($2 == pat) print $1 "." $2 }')
						vcftools --vcf $file --indv $patient --recode --out $out
					fi
                        	done
				if test $rm_flag = "True"
				then
					remove
				fi
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
						echo "$f"|awk -F'.' -v pat="$caller" '{ if ($2 == pat) print $1 "." $2 }'
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

