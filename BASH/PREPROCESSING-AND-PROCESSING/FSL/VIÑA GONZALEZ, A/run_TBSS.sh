# FSL_TBSS_pipeline
# Author: Biomedical Eng. Ariel Viña-González
# mail: arielvinag@gmail.com
# Date: June 2023
# Place: University of Granada

#Step 1.
path2results=/Users/name/Desktop/raw_data
database_file="subjects_database.txt"

# Creating the mytbss folder to store the TBSS outputs
mkdir "${path2results}/mytbss"

cd "$path2results" || exit 1

# Moving and renaming the result_FA.nii.gz file 
while read -r foldername || [[ -n "$foldername" ]]; do
    echo "Processing the folder: $foldername"
    folderpath="$path2results/$foldername"
    cd "$folderpath" || continue

    # Renaming the file 'result.nii.gz' with the current folder name.
    if [ -f result_FA.nii.gz ]; then
        cp result_FA.nii.gz "${foldername}.nii.gz"
        mv "${foldername}.nii.gz" "${path2results}/mytbss/"
    else
        echo "result.nii.gz file was not found in folder $foldername"
    fi
done < "$path2results/$database_file"

cd "${path2results}/mytbss"

# TBSS standard pipeline
#Step 1. TBSS implementation. For more detail about the differents flags that can be used, please visit: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TBSS/UserGuide
tbss_1_preproc *.nii.gz

#Step 2. TBSS implementation
tbss_2_reg -T

#Step 3. TBSS implementation
tbss_3_postreg -S

#Step 4. TBSS implementation
tbss_4_prestats 0.2

#Step 2. Running MD

mkdir "${path2results}/mytbss/MD"

while read -r foldername || [[ -n "$foldername" ]]; do
    echo "Processing the folder: $foldername"
    folderpath="$path2results/$foldername"
    cd "$folderpath" || continue

    # Rename the file result_MD.nii.gz to the name of the folder
    if [ -f result_MD.nii.gz ]; then
        cp result_MD.nii.gz "${foldername}.nii.gz"
        mv "${foldername}.nii.gz" "${path2results}/mytbss/MD"
    else
        echo "File result.nii.gz was not found in folder $foldername"
    fi
done < "$path2results/$database_file"

cd "${path2results}/mytbss/"

tbss_non_FA 

# Done!