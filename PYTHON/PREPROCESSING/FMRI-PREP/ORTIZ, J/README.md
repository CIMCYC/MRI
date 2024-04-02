# MRI-preprocessing

To preprocess using fmri-prep, follow the installation steps at https://fmriprep.org/en/1.5.5/docker.html


Docker is a container that must be previously installed (https://www.docker.com/).

Once fmri-prep is installed in Docker, you have to write in the terminal something similar to:
docker run -ti --rm -e 01 -v C:\Users\Usuario\Documents\PYTHON\RESONANCIA/:/data:ro -v C:\Users\Usuario\Documents\PYTHON\RESONANCIA\derivatives:/output -v  C:\Users\Usuario\Documents\PYTHON\RESONANCIA:/lic poldracklab/fmriprep:latest /data /output participant --participant_label 01 --fs-license-file /lic/license.txt --stop-on-first-crash

This must be modified according to your preprocessing. All the information is available in the previous link.


For any questions you can write to pilarsanpe@ugr.es or mariaruizromero@ugr.es
