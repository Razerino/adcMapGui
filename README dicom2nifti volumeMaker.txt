Ondrej Burkot, 2022

Script was written in MATLAB R2021b. 
It can be used for converting MRI DICOM data into NIfTI 3D/4D volume data.
This data are suitable for preprocessing using FSL or DIPY.

1) open script in MATLAB,
2) choose, if you wish to save data as 4D,
3) choose, if loaded data contains brain (option 'ano') or prostate ('ne'),
4) run script,
5) choose directory with DICOM data

Script recognizes only images of b value:
0, 50, 100, 150, 200, 500 and 1000 for brain images.

For prostate images:
0, 50, 100, 150, 200, 400, 800 and 1400.

NIfTI data are saved into directory chosen in step 5.
