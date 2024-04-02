# FSL_TBSS_pipeline
# Author: Biomedical Eng. Ariel Viña-González
# mail: arielvinag@gmail.com
# Date: June 2023
# Place: University of Granada

!/bin/bash

#interactive
#read -p "Please insert the folder path were the subjects DICOMs are stored: " path2rawdata
#read -p "Please enter the path to the folder where you want to store the DICOM .bvec, .bval and .nii.gz files.: " path2results

#non-interactive
#Change this path with your
 path2rawdata=/Users/name/Desktop/raw_data
 path2results=/Users/name/Desktop/output

# Check if the file "subjects_database.txt" already exists.
# The script creates a participants names data base in a text file to be used in the rest of the code in different stages.
if [[ -e "$path2results/subjects_database.txt" ]]; then overwrite 
fi

# Check if the folder "orig_data" already exists.
if [[ ! -d "$path2results/orig_data" ]]; then
    mkdir "$path2results/orig_data"
fi

# Read folder names from the path specified by path2rawdata
folders=("$path2rawdata"/*/)
printf "%s\n" "${folders[@]%/}" | awk -F/ '{print $NF}' > "$path2results/subjects_database.txt"

# Create folders in the folder "orig_data" according to the names in the file "subjects_database.txt".
while read -r foldername; do
    mkdir "$path2results/orig_data/$foldername"
done < "$path2results/subjects_database.txt"

# Creacion de los .bval , .bvec y .nii.gz de las DWI en DICOMs de los sujetos del estudio

folders=()

# Recursive function to search the folders
# Here you have to replce the names "MBep2d_diff_175iso_B300_d8", "MBep2d_diff_175iso_B300_d8_blip" and "MBep2d_diff_175iso_B1k_d32_blip" with the names of your DWI DICOM folders.
function buscar_folders {
  for folder in "$1"/*; do
    if [[ -d "$folder" ]]; then
      if [[ "$(basename "$folder")" == *"MBep2d_diff_175iso_B300_d8"* || "$(basename "$folder")" == *"MBep2d_diff_175iso_B300_d8_blip"* || "$(basename "$folder")" == *"MBep2d_diff_175iso_B1k_d32_blip"* ]]; then
        folders+=("$folder")
      else
        buscar_folders "$folder"
      fi
    fi
  done
}

# Search the folders and store their paths in the variable "folders".
buscar_folders "$path2rawdata"

# Convert the DICOM files of each found folder
for folder in "${folders[@]}"; do
  dcm2niix -z y -f "%f" -o "$folder" "$folder"
done

#Rename generated files with extension .bval, .bvec and .nii.gz by dcm2niix
for folder in "${folders[@]}"; do
  if [[ "$(basename "$folder")" == *"MBep2d_diff_175iso_B300_d8_blip"* ]]; then
    mv "$folder"/*.bval "$folder"/300PA.bval
    mv "$folder"/*.bvec "$folder"/300PA.bvec
    mv "$folder"/*.nii.gz "$folder"/300PA.nii.gz
  elif [[ "$(basename "$folder")" == *"MBep2d_diff_175iso_B300_d8"* ]]; then
    mv "$folder"/*.bval "$folder"/300AP.bval
    mv "$folder"/*.bvec "$folder"/300AP.bvec
    mv "$folder"/*.nii.gz "$folder"/300AP.nii.gz
  elif [[ "$(basename "$folder")" == *"MBep2d_diff_175iso_B1k_d32_blip"* ]]; then
    mv "$folder"/*.bval "$folder"/1000PA.bval
    mv "$folder"/*.bvec "$folder"/1000PA.bvec
    mv "$folder"/*.nii.gz "$folder"/1000PA.nii.gz
  fi
done

# Move .bval, .bvec and .nii.gz files to orig_data folder
# Step 1
# Get a list of the names of the folders in orig_data
cd "${path2results}/orig_data"
subjects2proc_folders=($(ls -d */ | sed 's#/##'))

# Search for folders with the same name in path2rawdata and save the paths in a file.
matches_file="${path2results}/matches.txt"
echo "The following folders match in both directories:" > "${matches_file}"
for folder in "${path2rawdata}"/*/; do
    foldername=$(basename "${folder}")
    if [[ "${subjects2proc_folders[@]}" =~ "${foldername}" ]]; then
        echo "${foldername} : ${folder} : ${path2results}/orig_data/${foldername}" >> "${matches_file}"
    fi
done

# Step 2
# Define the path to the matches.txt file
matches_file="${path2results}/matches.txt"

# Move the .bval, .bvec and .nii.gz files from the folders in path2rawdata to the corresponding ones in path2results/orig_data
while IFS= read -r line; do
  # Extract information from the current line
  foldername=$(echo "$line" | awk -F ' : ' '{print $1}')
  source_folder=$(echo "$line" | awk -F ' : ' '{print $2}')
  dest_folder=$(echo "$line" | awk -F ' : ' '{print $3}')

  cd "${source_folder}"

  # Search for .bval, .bvec and .nii.gz files in the current directory and its subdirectories.
  find . -type f \( -name "*.bval" -o -name "*.bvec" -o -name "*.nii.gz" -o -name "*.json" \) -exec mv {} "${dest_folder}" \;
done < "$matches_file"

# Copy the folders from orig_data out
cp -r "${path2results}/orig_data"/* "${path2results}"
cd "${path2results}"

# Remove the .json from folders outside of orig_data
# This step is optional, you can keep it if you prefer
while IFS= read -r folder || [[ -n "$folder" ]]; do
  find "$folder" -type f -name "*.json" -exec rm {} \;
done < subjects_database.txt

#Done!