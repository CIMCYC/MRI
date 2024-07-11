#!/bin/bash
#
#SBATCH --array 01
#SBATCH --partition=general1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=80
#SBATCH --mem-per-cpu=1024
#SBATCH --time=02:30:00
#SBATCH --no-requeue
#SBATCH --mail-type=ALL
# ------------------------------------------

echo "Loading singularity..."
spack load singularity@3.5.2

# Which subject do you want to run?
subject=01 # Change by your own

# Remove 'IsRunning' files from FreeSurfer
find ${FREESURFER_HOST_CACHE}/$subject/ -name "*IsRunning*" -type f -delete

# Re-direct some environmental variables to writable locations (Do not change)
export SINGULARITY_TMPDIR=/path/to/writable/location/fmriprep_temp/$subject
export SINGULARITY_CACHEDIR=/path/to/writable/location/.cache
export TEMP_DIR=/path/to/writable/location/fmriprep_temp/$subject
echo "creating temp directory in"
echo $TEMP_DIR
mkdir -p $TEMP_DIR

# Pass some variables into the container
export SINGULARITYENV_subject=$subject
export SINGULARITYENV_TEMPLATEFLOW_HOME=/templateflow

# Setup done, print a message and run the command
echo -e "\n"
echo "Starting fmriprep."
echo "subject: $subject"
echo -e "\n"

# Replace only this part of script according with your experiment (do not change anything after ':'):
singularity run \
	-B /path/to/writetable/location:/home/fmriprep \ # example: /home/usuario/Documentos/mystudy (do not change anything after ':')
	-B /path/to/data/BIDS:/data:ro \
	-B /path/to/templates/templateflow:/templateflow \  # example: /home/usuario/.cache/templateflow
	-B /path/to/output/folder:/output \
	-B /path/to/license:/lic \
	--home /home/fmriprep --cleanenv \
	/home/usuario/fmriprep-<version>.simg \  # path to your fmriprep image, change <version> (example: <version> = 24.0.0)
	/data /output participant \
	--notrack \
	--fs-license-file /lic/license.txt \
	--participant-label $subject \
