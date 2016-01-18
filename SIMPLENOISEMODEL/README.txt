USING the CRISM noise profile pipeline described in the LPSC_2014 paper also available in 
the dropbox.

The Code to be run is 'noiseProfilePipeline.m' in the folder 'SimpleNoiseModel'

The address of the image has to be entered in the file mentioned above following this the simply 
running the code file would generate the following outputs: -
-------------------------------------------------------------------------------------------------
OUTPUT
-------------------------------------------------------------------------------------------------

1) "imagename_colAvg20.img"                        : - the output of the column based averaging
2) "imagename_colAvg20_coarseDespike.img"          : - a coarse despiking of the Output-1
3) "imagename_colAvg20_coarseDespike_despike.img"  : - the neighborhood based despiking of Output-2
-------------------------------------------------------------------------------------------------


It is necessary that the folder 'SpikeRemoval' and it's sub-folders (also available here ) have to be on
the MATLAB Path.
