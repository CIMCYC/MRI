# FSL_TBSS_pipeline
# Author: Biomedical Eng. Ariel Viña-González
# mail: arielvinag@gmail.com
# Date: June 2023
# Place: University of Granada

!/bin/bash

path2results="/Users/name/Desktop/folder"
subjects_database="/Users/name/Desktop/output/subjects_database.txt"

# Going to the path results
cd "$path2results"

# Compute your own 5% of outliers quantity to know the criteria to discard an image.
# The DWI pulse sequence with b=1000 has 38 volums and 81 slices for a total of 3078 slices.
# The 5% of 3078 = 0.05 x 3078 = 153.9

echo "Action:    Folder_name:     Outlier_count:" >> outliersQC_counter_report.txt

# Read each folder listed in subjects_database.txt
while read folder; do
    # Count the number of lines in the file eddy_1000PA.eddy_outlier_report
    count=$(wc -l < "$folder/eddy_1000PA.eddy_outlier_report")
    # Check if number of lines is greater than 153
    if [ "$count" -gt 153 ]; then
        # If greater than 153, add the label "DISCARD".
        echo "exclude    $folder     $count" >> outliersQC_counter_report.txt
    else
        # If not greater than 153, type only the name of the folder and the number of lines
        echo "           $folder     $count" >> outliersQC_counter_report.txt
    fi
done < "$subjects_database"

# Create .csv file
# Convert outliersQC_counter_report.txt file to CSV format
sed 's/ \{1,\}/,/g' outliersQC_counter_report.txt > outliersQC_counter_report.csv.tmp

# Add column headings for the two new columns
sed -e '1 s/$/,eddy_1000PA_QC,SSE_QC/' outliersQC_counter_report.csv.tmp > outliersQC_counter_report.csv

# Separate the values of each column in different temporary files
awk -F "," '{
    print $1 > "columna1.tmp"
    print $2 > "columna2.tmp"
    print $3 > "columna3.tmp"
    print "eddy_1000PA_QC" > "columna4.tmp"
    print "SSE_QC" > "columna5.tmp"
}' outliersQC_counter_report.csv

rm -rf *.tmp

#Done!