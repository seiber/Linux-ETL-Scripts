1. TO RUN:

CD into project directory

3 parameters to pass in 
etl.sh servername,remove-userid, remote-file
The etl.sh script has all of the scripts required and will create files as necessary.
This script creates 6 different csv files, each file has different data in it that has been manipulated based off the script that was ran.
Features:
-reads a csv data file
-header removal
-converting text to lower case
-converting fields (gender in this case) ex. changing the letter 'm' to = 'male' or 'f' to 'female'
-filtering out specific data, eg filtering out data that doesn't have a state.
-removing $ sign on fields
-sorting columns
-creating a sum for customers
-sorting a file
-creating a Reports: summary, transaction, and purchase,


