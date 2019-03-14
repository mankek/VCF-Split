Bash tool that takes a multi-sample VCF and splits it into multiple individual 
VCFs. Uses vcftools to perform splitting. 

If there are sample columns with the same sample ID, but different caller IDs within the 
multi-sample file, splitting by sample ID will create a different vcf for each variant caller used.

Usage:

Once executable permission is given to the file, run it as follows:

  ./vcf_split -options
  
Options

-h: Displays help menu

-i: Specifies input multi-sample vcf

-o: Split VCF file output location; each output vcf file will be sent to this location, but will automatically named by sample ID

-c: If samples used different variant callers, specifies the variant caller for which samples should be split or printed; optional

-r: This option removes log files for non-selected samples when a specific caller is set for splitting

-p: Prints a list of all samples found in the input vcf. Setting the -c argument will print all sample IDs with the specified caller.

-s: performs splitting on the input vcf. Setting -c argument will split out samples with the specified caller.
