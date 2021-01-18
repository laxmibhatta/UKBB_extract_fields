cd /mnt/archive/laxmi/ukb_extract_fields/

input=/mnt/archive/laxmi/ukb_extract_fields   #/mnt/work/ukb/phenotypes
tmp=/mnt/archive/laxmi/ukb_extract_fields     #/mnt/archive/laxmi/tmp
output=/mnt/archive/laxmi/ukb_extract_fields

awk 'NR==FNR {stage[$1]=$0; next;}; {print $0,stage[$1]}' $input/ukb31008.tab  $input/ukb43682.tab > $tmp/tmp1.txt
awk 'NR==FNR {stage[$1]=$0; next;}; {print $0,stage[$1]}' $input/ukb28673.tab  $tmp/tmp1.txt   > $tmp/tmp2.txt
awk 'NR==FNR {stage[$1]=$0; next;}; {print $0,stage[$1]}' $input/ukb22892.tab   $tmp/tmp2.txt  > $output/ukb.txt

# find column names from part of it
head -1 $output/ukb.txt | tr '\t' '\n' | cat -n | grep '\f.eid\|\f.53\.\|\f.21022\.\|\f.31\.\|\f.50\.\|\f.21001\.\|\f.21002\.\|\f.21000\.\|\f.20116\.\|\f.26414\.\|\f.26431\.\|\f.26421\.\|\f.6164\.\|\f.40000\.\|\f.40001\.\|\f.22502\.\|\f.22503\.\|\f.22504\.\|\f.22505\.\|\f.2316\.\|\f.4717\.\|\f.20002\.\|\f.20001\.\|\f.1508\.\|\f.1498\.\|\f.1488\.\|\f.1418\.\|\f.20152\.\|\f.3088\.\|\f.3089\.\|\f.3090\.\|\f.3159\.\|\f.20255\.\|\f.3061\.\|\f.3062\.\|\f.20151\.\|\f.3063\.\|\f.20150\.\|\f.6138\.\|\f.20277\.\|\f.191\.' > $tmp/tmp4.txt

# have two column, so print the column with fields
awk '{print $2}' $tmp/tmp4.txt | sort -k1V,1  > $tmp/tmp5.txt  #fields_names.txt

cut -f"$({ echo 1 
head -n1 $output/ukb.txt | tr '\t' '\n' | grep -Fxn  -f $tmp/tmp5.txt
} | cut -f1 -d: | paste -sd,)" $output/ukb.txt > $tmp/tmp6.txt

transpose () {
  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i; max=(max<NF?NF:max)}
        END {for (i=1; i<=max; i++)
              {for (j=1; j<=NR; j++) 
                  printf "%s%s", a[i,j], (j<NR?OFS:ORS)
              }
        }'
}
cat  $tmp/tmp6.txt | transpose | awk '!a[$1]++ {print $0}' | sort -k1V,1 | transpose  > $output/ukb_project_coffee_lung.txt

Rscript 2.0_extract_ukb_fields.R

rm $tmp/tmp*

