PREPROCESSING MRI

Until you get acquainted with the script it is very, very important that you stop and examine the output of each of the steps of the preprocessing. This will help you to conceptually understand the various fixes and also to identify faults or artefacts. In other words, always check with the first participants that all the steps are being carried out properly and the images are changing as expected.

Almost everything you'll need to tweak for your experiment is at the beginning of the code. 

First, you must indicate what corrections you want to make due to the preprocessing: 
-De-face (or anonymization of images). 
-Fieldmap (or magnetic field correction). 
-Realignment. 
-Slice timing. 
-Coregister (co-registration of T1 to functional images). 
-Segmentation (segmentation of the T1 image). 
-Normalization (normalization to the common space). 
-Smoothing. 

For a conceptual explanation of these steps, we recommend reading the chapter on preprocessing in the Huettel book. 

Next, you will need to update the squence parameters that you used in your experiment: 
-Number of runs. 
-Number of slices per volume. 
-TR (or repetition time). 
-TA (TR – TR/No of slices). 
-Slice order (order in which the slices were collected, can be: ascending, descending or intercalated). 

For the reference slice and the type of smoothing we will leave default values. 

In this point, you only have to adjust the directories where you have stored your images in BIDS format. 

Finally, throughout the script, files that are included in the folder where SPM is installed are called several times. You must update that path to match the path of the PC you are using. Just search every time that it appears in the code: “C:\Users\carlos\Documents\MATLAB\spm12\” and replace it with the path of your computer. 
 
Once all this is done, you can run the preprocessing_BIDS_SPM12. m code. 
