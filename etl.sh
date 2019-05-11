#Dakota Seiber

#1. Transfer file (done)
scp $1@$2:$3 .
echo " File transfer complete"

#2 unzip the transaction file
bzip2 -dk MOCK_MIX_v2.1.csv.bz2
#rename to mock
mv MOCK_MIX_v2.1.csv mock.csv

echo " file unziped"

#3 Remove header record from file (done)
tail -n +2 mock.csv >test3.csv
echo " header removed"

#4 Convert all text in the file to lower case. (done)
sed 's/\([A-Z]\)/\L\1/g' test3.csv > test.csv

echo " text converted to lower case"

#5 Convert gender fields
awk -F\, 'BEGIN {OFS=FS} $5=="1" {$5= "f"} $5=="0" {$5 = "m"} $5=="male" {$5="m"} $5=="female" {$5="f"} $5=="" {$5="u"} i;1' test.csv >test1.csv

echo " gender fields sucessfully converted"

#6 filter out records that don't have a state or contain "NA" (done)
awk -F\, '$12=="" || $12=="na"' test1.csv> exceptions.csv
awk -F \, '$12!="" && $12!="na"' test1.csv > test2.csv

echo " all records filtered out"

#7 remove the $ from field 6 (done)
awk -F"," '{gsub(/[$ ]/,"",$6)}1' OFS="," test2.csv >test4.csv

echo "$ sign removed"

#8 sort column1 (with numbers and letters) 1,1 to sort starting with col 1 and only col 1

echo " column sorted"
sort -k 1,1 test4.csv > transaction.csv

#9 accumulate a total for each customer (fields 1,6)
#order: cust id($1), state($12),zip ($13),lastname($3),firstname($2),total($6)
awk 'BEGIN {OFS=","; FS = ","; CUST_ID = "Begin"; STATE=""; ZIP=""; LN=""; FN=""; TOTAL=0;} {if ($1 != CUST_ID) {if (CUST_ID!="Begin") {printf "%s,%s,%s,%s,%s, %f\n", CUST_ID,STATE,ZIP,LN,FN,TOTAL} CUST_ID=$1;STATE=$12; ZIP=$13; LN=$3; FN=$2; TOTAL=0;} TOTAL+=$6;} END {printf "%s,%s,%s,%s,%s,%f \n", CUST_ID,STATE,ZIP,LN,FN, TOTAL} ' transaction.csv >sum1.csv

echo " total accumulated for each customer"

#10 sort the summary file (state,zip,ln,fn)
sort -f -t"," -k2,2 -k3,3 -k4,4 -k5,5nr sum1.csv >summary.csv

echo " summary file sorted"

#11 Transaction Count Report
awk -F ',' '{print $12}' mock.csv |sort |uniq -c | sort -rn >trans.csv

#add header

sed '1i Transaction Count Report \n State, Transaction Count' trans.csv>transaction-rpt.csv

echo " transaction count report created"

#purchase report summary state,gender,purchase amount   (partially working)

awk 'BEGIN {OFS=","; FS = ","; STATE= "Begin"; GENDER=""; TOTAL=0;} {if ($12!=STATE) {if (STATE!="Begin") {printf "%s,%s,f\n", STATE,GENDER,TOTAl} STATE=$12; GENDER=$5; TOTAL=0;} TOTAL+=$6;} END {printf "%s,%s,%f \n", STATE,GENDER,TOTAL} ' transaction.csv >sum.csv

sed '1i Purchase Summary Report\n State, Gender, Purchase Amount' sum.csv > summary-rpt.csv

echo " purchase report created"

#13 remove intermediary files
rm test.csv
rm test1.csv
rm test2.csv
rm test3.csv
rm test4.csv
#rm sum1.csv
rm sum.csv
rm trans.csv


echo "intermediary files removed"




