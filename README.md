This repository is for a small, simple command-line tool that takes a multi-sample VCF and splits it into multiple individual 
VCFs. Requires that vcftools be installed and if there are multiple variant callers used on the same samples within the 
multi-sample file, a different vcf will be made for each variant caller used.

Use:

-h: Displays help menu

-i: Specifies input multi-sample vcf

-p: Prints a list of all patients found in the input file

-s: performs splitting on the input file
