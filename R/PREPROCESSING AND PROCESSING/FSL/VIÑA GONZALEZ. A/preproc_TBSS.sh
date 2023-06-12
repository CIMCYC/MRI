# FSL_TBSS_pipeline
# Author: Biomedical Eng. Ariel Viña-González
# mail: arielvinag@gmail.com
# Date: June 2023
# Place: University of Granada

!/bin/bash

#Step 1.
path2results=/Users/name/Desktop/raw_data
database_file="subjects_database.txt"

# Creation of avance_preproc.txt file
if [ -f "avance_preproc.txt" ]; then rm "avance_preproc.txt"; fi
touch "$path2results/avance_preproc.txt"

# Read the database file and scroll through each line
while read -r foldername || [[ -n "$foldername" ]]; do
    echo "Processing the folder: $foldername"
    echo "Processing: $foldername $(date '+%Y-%m-%d %H:%M:%S')" >> "$path2results/avance_preproc.txt"
    folderpath="$path2results/$foldername"
    cd "$folderpath" || continue
    
    # Execute the commands in the current folder
    fslroi 300AP AP_b0 0 2
    fslroi 300PA PA_b0 0 2
    fslmerge -t AP_PA_b0 AP_b0 PA_b0
    
    # Change this parameters taking account the characteristics of your pulse sequence.
    # The value that goes here is the TotalReadoutTime available in the .json file created during the DWI conversion to nii format using dcm2niix.
    printf "0 1 0 0.0725\n0 1 0 0.0725\n0 -1 0 0.0725\n0 -1 0 0.0725" > acqparams.txt

    fslroi AP_PA_b0.nii.gz AP_PA_b0.nii.gz 0 118 0 118 0 82 0 4
    fslroi 1000PA.nii.gz 1000PA.nii.gz 0 118 0 118 0 82 0 38
    
    #Running the topup
    echo "Topup" >> "$path2results/avance_preproc.txt"
    topup --imain=AP_PA_b0 --datain=acqparams.txt --config=b02b0.cnf --out=topup_PA_AP_b0 --fout=my_field --iout=my_hifi_b0

    fslmaths my_hifi_b0 -Tmean my_hifi_b0
    bet my_hifi_b0 my_hifi_b0_brain -m -f 0.5

    indx=""
    for ((i=1; i<=38; i+=1)); do indx="$indx 3"; done
    echo $indx > index.txt
    
    #Running the eddy correction
    echo "Eddy" >> "$path2results/avance_preproc.txt"
    eddy --imain=1000PA.nii.gz --mask=my_hifi_b0_brain_mask --acqp=acqparams.txt --index=index.txt --bvecs=1000PA.bvec --bvals=1000PA.bval --topup=topup_PA_AP_b0 --repol --cnr_maps --out=eddy_1000PA
    cp 1000PA.bval bvals
    cp eddy_1000PA.eddy_rotated_bvecs bvecs
    
    # Running the dtifit to generate the DWI metrics
    echo "dtifit" >> "$path2results/avance_preproc.txt"
    dtifit -k eddy_1000PA.nii.gz -o result -m my_hifi_b0_brain_mask -r bvecs -b bvals --sse

    echo "Finishing the folder procesing: $foldername"
    echo "Finish: $foldername $(date '+%Y-%m-%d %H:%M:%S')" >> "$path2results/avance_preproc.txt"
done < "$path2results/$database_file"


# FSL_QUAD

#Step 1.
subjects_database="/Users/name/Desktop/raw_data/subjects_database.txt"

# Going to the results path
cd "$path2results"

# Iterate over each line of the subjects_database.txt file.
while IFS= read -r subject; do
  # Access the subject directory
  cd "$subject"
  # Run the eddy_quad command
  eddy_quad eddy_1000PA -idx index.txt -par acqparams.txt -m my_hifi_b0_brain_mask.nii.gz -b bvals
  # Back to results directory
  cd "$path2results"
done < "$subjects_database"

#Done!