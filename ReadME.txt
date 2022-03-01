The code we implemented for our project is organised as follows:
- A. 	Lambert-Beer law and signal filtering
- B_NM. 	task segmentation and feature extraction (for non-mediated task epochs)
- B_M. 	task segmentation and feature extraction(for mediated task epochs)
- C_NM. 	SVM construction and classification (for non-mediated task epochs)
- C_M. 	SVM construction and classification (for mediated task epochs)
- D. 	MANOVA statistical test results
- E. 	Classification results analysis

There are variables inside the scripts that allow the user to choose whether to visualize each plot. The variables are defined right before the plot code.
The results of each step are stored in workspaces automatically saved in the folder named 'Results'. The scripts must be run in the given sequence to generate these workspaces, which are imported by the following scripts.


The functions we used can be found in the folder named 'Functions':
- svm_statistical: SVM net using statistical features
- svm_temp: SVM net using temporal average as features
- MANOVA_calc: MANOVA statistical test implementation
In the same folder we included also the workspace called 'green_red_cmap', containing the color vector we used for the topographical plot of the p-value.

NOTE: in order to correctly run the whole script, it is mandatory to install Matlab "Plot_Topography" toolbox. 

