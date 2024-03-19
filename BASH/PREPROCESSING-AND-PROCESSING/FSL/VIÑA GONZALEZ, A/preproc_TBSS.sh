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
    
    # Extract two volumes from AP_b0 and PA_b0 files. These commands use the "fslroi" tool to extract two volumes from the "300AP" and "300PA" files. The extracted volumes are saved as "AP_b0" and "PA_b0", respectively.
    fslroi 300AP AP_b0 0 2
    fslroi 300PA PA_b0 0 2
    fslmerge -t AP_PA_b0 AP_b0 PA_b0
    
    # Change this parameters taking account the characteristics of your pulse sequence.
    # The value that goes here is the TotalReadoutTime available in the .json file created during the DWI conversion to nii format using dcm2niix.
    printf "0 1 0 0.0725\n0 1 0 0.0725\n0 -1 0 0.0725\n0 -1 0 0.0725" > acqparams.txt
    
    # These commands also use "fslroi" to extract specific regions of interest from the files "AP_PA_b0.nii.gz" and "1000PA.nii.gz". The extracted regions are specified using cut-off values and stored in the same source files.
    fslroi AP_PA_b0.nii.gz AP_PA_b0.nii.gz 0 118 0 118 0 82 0 4
    fslroi 1000PA.nii.gz 1000PA.nii.gz 0 118 0 118 0 82 0 38
    
    # Running the topup. (For more information see: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup)
    # This command executes the "topup" tool to perform distortion correction on the images. It uses the following files and parameters:

    # --imain: input file, in this case, "AP_PA_b0"
    # --datain: acquisition parameter file, in this case, "acqparams.txt"
    # --config: configuration file, in this case, "b02b0.cnf"
    # --out: prefix for the output files, in this case, "topup_PA_AP_b0"
    # --fout: output file containing the corrected field, in this case, "my_field"
    # --iout: output file containing the corrected images, in this case, "my_hifi_b0"
    
    echo "Topup" >> "$path2results/avance_preproc.txt" # This line is optional, you can delete if you want. It's just to create a log of the processing advance.
    topup --imain=AP_PA_b0 --datain=acqparams.txt --config=b02b0.cnf --out=topup_PA_AP_b0 --fout=my_field --iout=my_hifi_b0

    # These commands use "fslmaths" and "bet" to perform brain segmentation:
    # The first command calculates the temporal mean ("-Tmean") of the "my_hifi_b0" file and overwrites the same file.
    # The second command applies the "bet" command to generate a brain mask from the "my_hifi_b0" file. The mask is saved as "my_hifi_b0_brain_mask" and a threshold of 0.5 ("-f 0.5") is applied for more precise segmentation.

    fslmaths my_hifi_b0 -Tmean my_hifi_b0
    bet my_hifi_b0 my_hifi_b0_brain -m -f 0.5

    # These lines initialize an empty string variable indx. Then, using a for loop, the variable indx is updated by appending the value 3 to it in each iteration. This loop runs 38 times. Finally, the value of indx is saved in a file called index.txt.
    indx=""
    for ((i=1; i<=38; i+=1)); do indx="$indx 3"; done
    echo $indx > index.txt
    
    #Running the eddy correction (For more information see: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy)
    # These lines first print a comment indicating that the eddy correction process is about to start. The comment is appended to the "avance_preproc.txt" file.
    # Then, the eddy command is executed to perform eddy current correction and motion correction on the input file "1000PA.nii.gz". The correction is performed using various input files and parameters such as the brain mask, acquisition parameters, index file, b-vectors, b-values, and the results from the previous topup correction. The output of the eddy correction is saved as "eddy_1000PA".
    # After that, the cp command is used to make copies of the "1000PA.bval" and "eddy_1000PA.eddy_rotated_bvecs" files, renaming them as "bvals" and "bvecs", respectively. 

    echo "Eddy" >> "$path2results/avance_preproc.txt" 
    eddy --imain=1000PA.nii.gz --mask=my_hifi_b0_brain_mask --acqp=acqparams.txt --index=index.txt --bvecs=1000PA.bvec --bvals=1000PA.bval --topup=topup_PA_AP_b0 --repol --cnr_maps --out=eddy_1000PA
    cp 1000PA.bval bvals
    cp eddy_1000PA.eddy_rotated_bvecs bvecs
    
    # Running the dtifit to generate the DWI metrics (For more information see: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide)
    # These lines first print a comment indicating that the dtifit process is about to start. The comment is appended to the "avance_preproc.txt" file.
    # Then, the dtifit command is executed to generate diffusion tensor metrics from the corrected DWI data. The command takes several inputs such as the corrected DWI image ("eddy_1000PA.nii.gz"), the output prefix ("result"), the brain mask ("my_hifi_b0_brain_mask"), the b-vectors ("bvecs"), the b-values ("bvals"), and the option --sse for the summation of squared errors.
    
    echo "dtifit" >> "$path2results/avance_preproc.txt"
    dtifit -k eddy_1000PA.nii.gz -o result -m my_hifi_b0_brain_mask -r bvecs -b bvals --sse

    # These lines print a comment indicating the completion of the folder processing, including the name of the folder being processed. The comment is appended to the "avance_preproc.txt" file. Additionally, another comment is printed, including the folder name and the current date and time, and it is also appended to the same file.
    # The done < "$path2results/$database_file" part indicates the end of the while loop that iterates through each line of the "subjects_database.txt" file.   
    
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
  # Run the eddy_quad command. Full explication (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddyqc/UsersGuide)
  eddy_quad eddy_1000PA -idx index.txt -par acqparams.txt -m my_hifi_b0_brain_mask.nii.gz -b bvals
  # Back to results directory
  cd "$path2results"
done < "$subjects_database"

#Done!