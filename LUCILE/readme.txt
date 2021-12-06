Dataset: Breast Cancer Diagnostic

Aim: Predict whether the cancer is benign or malignant

Hypothesis: Some features of the cell nuclei of a breast mass's fine needle aspirate permit to predict whether the cancer is benign or malignant

_____________________________________________________________________________________________________________________________________

Information about the dataset :

569 observations, 32 variables

The variables describe characteristics of the cell nuclei present in digitized images of a fine needle aspirate (FNA) of a breast mass.

- "id":                int         ID number 
- "diagnosis"          fac         M = malignant, B = benign 

The 30 remaining variables are the mean ("mean"), standard error ("se") and worst case ("worst") of the 10 following features:

1) "radius"            num         distances from center to points on the perimeter
2) "texture"           num         standard deviation of gray-scale values 
3) "perimeter"         num         perimeter of the nucleus 
4) "area"              num         area of the nucleus
5) "smoothness"        num         local variation in radius lengths 
6) "compactness"       num         perimeter^2 / area - 1.0 
7) "concavity"         num         severity of concave portions of the contour 
8) "concave.points"    num         number of concave portions of the contour 
9) "symmetry"          num         symmetry of the nucleus 
10)"fractal_dimension" num         "coastline approximation" - 1

Features are computed for each cell nucleus

All feature values are recoded with four significant digits.
