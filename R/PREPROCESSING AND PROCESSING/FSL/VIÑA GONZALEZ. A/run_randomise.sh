# FSL_TBSS_pipeline
# Author: Biomedical Eng. Ariel Viña-González
# mail: arielvinag@gmail.com
# Date: June 2023
# Place: University of Granada

!/bin/bash

# Step 1.
path2results=/Users/name/Desktop/output

all_FA_skeletonised=$(find "$path2results/mytbss/stats" -name "all_FA_skeletonised.nii.gz")
mean_FA_skeleton_mask=$(find "$path2results/mytbss/stats" -name "mean_FA_skeleton_mask.nii.gz")

# Step 2.
# This analysis is for FA but is the same for MD, you just need to replace the file all_FA_skeletonised and mean_FA_skeleton_mask with the corresponding MD files.
for design_mat in $(find "$path2results/design" -name "*.mat"); do
  # Step 3.
  filename=$(basename "$design_mat" .mat)
  echo "$filename" >> "$path2results/avance_randomise.txt"
  randomise -i "$all_FA_skeletonised" -o "$path2results/design/${filename}" -m "$mean_FA_skeleton_mask" -d "$design_mat" -t "${design_mat%.*}.con" -n 500 --T2 -D
done

#Done!