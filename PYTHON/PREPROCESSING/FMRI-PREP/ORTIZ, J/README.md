# MRI-preprocessing

To preprocess using fmri-prep, follow this link and its steps 'https://fmriprep.org/en/stable/usage.html'. Here it is all information, with details.
First, you have to download fmriprep image, following the steps of link.

Then, you have to write 'singularity build /home/user/fmriprep-<version>.simg \
                    docker://nipreps/fmriprep:<version>' 
in terminal to install fmriprep. (<version> = number, example: 24.0.0)

Docker is a container that must be previously installed (https://www.docker.com/). After, it is necessary install Singularity (https://www.nipreps.org/apps/singularity/)

You also have to download the templates that you are going to need to preprocess. Templates can be downloaded with the Python api and using the syntax below (choose the templates that you need, one by one). 

 python3

 from templateflow import api as tflow

 tflow.get('MNI152NLin2009cAsym')

 tflow.get('OASIS30ANTs')

 tflow.get('MNI152NLin6Asym')

 tflow.get('fsaverage')

 tflow.get('NKI')

 tflow.get('MNI152NLin2009cSym')

 tflow.get('WHS')

 tflow.get('fsLR')

 tflow.get('MNIPediatricAsym')

 tflow.get('MNI152Lin')

 tflow.get('MNIInfant')

 tflow.get('MNI152NLin6Sym')


To continue, it is necessary to prepare the script 'example-fmriprep_cluster.sh' in order to do preprocessing, according with your experiment. All this information is available in this link (https://sites.google.com/view/to-future-me/blog/how-to-fmriprep-singularity).

Once fmri-prep is installed, and the previous script is prepared, you have to run it in terminal something like this:
'bash example-fmriprep_cluster.sh' in order to preprocess your data.


For any questions you can write to pilarsanpe@ugr.es or mariaruizromero@ugr.es
