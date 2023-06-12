# FSL_TBSS_pipeline
# Author: Biomedical Eng. Ariel Viña-González
# mail: arielvinag@gmail.com
# Date: June 2023
# Place: University of Granada

!/bin/bash

# Get the name of the current directory
directory_name=$(basename "$(pwd)")

# Report file name
report_file="${directory_name}_cluster_report.txt"

# Array with filenames to be replaced. Here you have to put the names of the glm_GUI designed matrix of interest to report.
file_names=(
  "VAR1"
  "VAR2"
  "VAR3"
)

# Scrolls through each filename
for name in "${file_names[@]}"; do
  # Here you have to set the number of contrast that you created.
  # This is an example with just 2 contrast. If you want 4, change {1..2} for {1..4}
  # Execute cluster command for each number from 1 to 2
  for number in {1..2}; do
    # Input file name
    input_file="${name}_tfce_corrp_tstat${number}.nii.gz"
    
    # Save the file name in the report
    echo "Input file: $input_file" >> "$report_file"
    
    # Run the FSL cluster command and save the output in the report.
    cluster -i "$input_file" -t 0.95 >> "$report_file"
    
    # Adds a blank line after each execution
    echo "" >> "$report_file"
  done
done

#Done!