## TBSS Pipeline - README

### Introduction
Welcome to the TBSS Pipeline repository! This project aims to provide a streamlined and efficient pipeline for analyzing diffusion-weighted magnetic resonance imaging (DWI) data using FSL's TBSS (Tract-Based Spatial Statistics) tool. This pipeline run fully in command prompt console so, no GUI interfeace is neccesary.

### Social Media Profiles
Stay updated with our latest developments and news by following us on social media:
- Twitter: https://twitter.com/cimcyc

### Project Overview
The TBSS Pipeline project offers a comprehensive solution for processing and analyzing DWI data. By implementing FSL's TBSS tool, researchers can perform voxel-wise statistical analyses to explore the microstructural properties of white matter tracts in the brain. This pipeline provides a standardized workflow that encompasses preprocessing, registration, and statistical analysis, enabling users to derive valuable insights from their DWI data.

### Key Features and Benefits
- **Efficiency:** The pipeline can be use in local computer or in a high-performance computing (HPC) architectures like Albaicín (https://supercomputacion.ugr.es/informacion/como-acceder/).
- **Reproducibility:** All scripts and processing steps are transparently documented, ensuring that the results can be reproduced and verified by other researchers.
- **User-Friendly:** The pipeline includes code comments minimizing the need for technical expertise and facilitating usability for a wide range of researchers.
- **Quality Control:** Rigorous quality control measures have been integrated into the pipeline to ensure the reliability and accuracy of the processed data.
- **Open Source:** The TBSS Pipeline project is open-source and hosted on GitHub, enabling collaboration, contribution, and customization by the scientific community.

### Getting Started
To start using the TBSS Pipeline, follow these steps:

1. Clone or download the repository to your local machine.
2. Ensure that you have FSL installed and properly configured.
3. Prepare your DWI data in DICOM format and organize it in a suitable directory structure.
4. Customize the pipeline scripts to specify the paths to your data and desired output directories.
5. Run the pipeline using the provided command-line interfaces or adapt the scripts for your specific needs.

### Workflow:

1. Execute 'data_organization.sh' to organize and convert your data.
2. Execute 'preproc_TBSS.sh' to preprocess your DWI data. (this step is recommend to be run in Albaicin HPC, see the 'Directives2runInAlbaicin.txt')
4. Excecute 'outliersQC_counter.sh' to create the PDF report of image quality control. (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddyqc/UsersGuide)
5. Execute 'run_TBSS.sh' to process the data using TBSS. (this step is recommend to be run in Albaicin HPC, see the 'Directives2runInAlbaicin.txt')
6. Use glm_gui to create your design for further analysis.
7. Execute 'run_randomise.sh' to perform statistical analysis. (this step is recommend to be run in Albaicin HPC, see the 'Directives2runInAlbaicin.txt')
8. Use 'run_cluster_report.sh' to generate a report on your randomise results.
9. Visualize the results using fsleyes.

Note: Make sure to adjust the necessary parameters and paths within the scripts according to your specific data and requirements.

### Support
If you encounter any issues or have questions regarding the TBSS Pipeline, please reach out to our support team at mailto: arielvinag@gmail.com. We are committed to providing prompt assistance and resolving any concerns you may have.

### Contributors and Maintainers
The TBSS Pipeline project welcome contributions from the scientific community to further enhance the functionality and usability of the pipeline. 

Thank you for choosing the TBSS Pipeline for your DWI data analysis needs. We hope this pipeline proves to be a valuable tool in your research endeavors.

**Project Lead:** Mar Martín Signes (mail: msignes@ugr.es)
                  Ana Belén Chica Marínez (mail: anachica@ugr.es)

**Development Team:** Ariel Viña-González (mail: arielvinag@gmail.com)