# App_for_lungs_reconstruction

The aim of the project is to reconstruct the 3D lung tree from cross-sectional photos of the chest, using the Matlab environment and image processing methods such as image segmentation. It is required that the photos are the same size and arranged in descending order in relation to the name.

# Application Examples
<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex1.png">
</p>

# Introducing

Image segmentation is an essential part of the image processing process. It enables the analysis of parts - objects extracted from the image. Segmentation is the process of dividing an image into coherent areas homogeneous in terms of a certain criterion, which are related to the objects in the image. The criterion can be:
- intensity
- intensity gradient
- color
- characteristic textures

The result of segmentation is the image of identifiers, where each object is assigned a different identifier, while all points belonging to one object have the same identifier. Identifiers are often consecutive natural numbers. However, this rule loses its relevance in the case of binarization.

## Image segmentation methods

The literature on image processing is extensive, so segmentation techniques available tens occur. Some of them are:
- thresholding
- edge detection
- classification 
- grouping 
- watershed segmentation
- binarization
- growing area

The appropriate segmentation method is selected specifically for the image being processed. Its choice depends on the complexity of the image. This often requires complex multi-step methods.

## Thresholding

Thresholding is the simplest segmentation method. It is based on pixel intensities and compares their values with a given threshold value, which enables the image to be split into an object and a background. However, if the effect of an action is to isolate more than one object, this case is called classification or grouping. The effect of thresholding is visible in the image, separable areas usually marked with two different colors (eg black and white for binarization). When using multi-criteria thresholding, successive shades of gray are used.

### Types of thresholding
- binarization - split the image into black and white.
- pseudo-thresholding - in this case, the result will not be two areas, but a set of points with intensities "t" within a given range.
- multiple thresholding - many criteria that determine the intensity of grayscale.
- dynamic thresholding - in the case of dynamic thresholding, the threshold value is not global but depends on the spatial co-ordinates. Due to the method of determining the threshold, we  dynamic local methods and adaptive methods.

## Growth area segmentation

The growing area segmentation method involves selecting a pixel of a given intensity, defining a threshold, and then examining adjacent pixels called neighbors to see if they meet the intensity criterion. If so, these pixels are added to the object's pixel and the next examination starts with them as start pixels. In this method, the main problem is the choice of the neighborhood method. We distinguish:
1. Segmentation 2D
- 4-neighborhood
- 8-neighborhood

2. Segmentation 3D
- 6-neighborhood
- 12-heighborhood
- 26-neighborhood

Neighborhood is understood as the surroundings of a given point.
Algorith growth area segmentation:

    1. Insert the starting point into the queue
    
    2. Mark the starting point as visited
    
    3. Add a starting point to the object
    
    4. As long as the queue is not empty:
    
      a) Select a point at the beginning of the queue
      
      b) Delete a point in the queue
      
      c) For each unvisited point neighbor:   
      
         c2) Mark the point as visited    
         
         c3) If it meets the inclusion criterion:  
         
             - Add point to the object        
             
             - Insert its neighbors to the queue
            
The criterion can be static, e.g. a given intensity, or dynamic, e.g. the average intensity in a given area.

## Mathematical morphology

### Dilatation

Dilation is a procedure of applying Minkowski's sum to the image. It consists in applying a rotated structural element to each pixel in the image, when at least one chick within the structural element has the value 1, the central value of the element is replaced with 1.

### Erode 

Erode is a process of applying Minkowski's difference to the image. It consists of applying a rotated structural element to each pixel in the image, when at least one pixel within the structural element is equal to 0, then the central value of the element is replaced by 0.

# Implementation

## Database 

For the implementation of the project, we used to tomographic images of the lungs in the ".dcm" format. The size of the photos is 512x512. In the Aplikacja.mlapp application, we select the images that represent / cover the lung area.
Using the ```uigetdir``` function, the folder containing the tomographic image database was selected, and using the loop, each image or only the important ones that would be needed for the reconstruction and to help the function ```C=cat(dim,A,B) ``` to combine the images.

## Lung segmentation

At this stage, we segment the lungs using thresholding. Choose the threshold, in the tested images, the best threshold is 17990. Lung segmentation function:

```
function [BW,maskedImage] = segmentImage(X,T)
X = imadjust(X);
BW = X > T;
BW = imcomplement(BW);
BW = imclearborder(BW);
radius = 3; 
decomposition = 0;
se = strel('disk', radius, decomposition);
radius = 3;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imdilate(BW, se);
maskedImage = X;
maskedImage(~BW) = 0;
end
```
- ``` X=imadjust(X) ``` - maps the grayscale image intensity values of X to new X values. By default ``` imadjust ```, saturates the bottom 1% and top 1% of all pixel values. Increases the contrast of the output X image.
- Image thresholding - Then the threshold is the output image ``` BW=X>T ```where the threshold value is set in the main program.
- Mask inversion - the mask inversion function imcomplement (BW), to remove noise outside the lung area, using the imcomplement (BW) function - suppresses structures in the image that are brighter than their surroundings and which are connected to the image frame.
- Mathematical morphology - the last step is to fill in and remove the last noises outside the lung area, and for this purpose mathematical morphology is used. Opening operations were used, the same parameters were used for morphological functions, starting with erode and ending with dilatation.

The threshold value was selected manually on the basis of the value of the pixel intensity of the pulmonary trunk and the knowledge of the human thoracic anatomy. In the application, we have more control over the selected parameters. The result is segmented lungs after applying the mask to the image:

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex2.png">
</p>

## bronchial segmentation

At this stage the bronchi are segmented. Function ```function[BW,maskedImage] = segmentBronchas(X,T,row,column,tolerance)``` :

```
function [BW,maskedImage] = segmentBranchos(X,T,row,column,tolerance)
X = imadjust(X);
BW = X > T  ;                                            
addedRegion = grayconnected(X, row, column, tolerance);
BW = BW | addedRegion;
BW = imclearborder(BW);
maskedImage = X;
maskedImage(~BW) = 0;
end

```
- Contrast improvement - similar to the first function with lung segmentation.
- Removing contours - removing the contours of the lungs that were created during lung segmentation for this purpose the function ```grayconnected``` was used - selects a continuous area of  image with similar gray values using filling techniques. ```BW=grayconnected(I,row,column)``` specifies a range of intensity values to include in the mask.
- Second process contour removing - individual fragments and noises were removed with ```imclearborder```.

Results:

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex3.png">
</p>

## Pulmonary trunk segmentation

The last stage is the segmentation of the pulmonary trunk, for this purpose the program code from laboratory activities was used from image processing from segmentation-area enlargement. 26th neighbors added in function ```[neighbours]=Fun_neighbors(c,x,y,z,neighbours)```:

```
    case 26
        sasiedzi=[  c(1)-1,c(2)+1,c(3)+1; c(1),c(2)+1,c(3)+1; c(1)+1,c(2)+1,c(3)+1;
                    c(1)-1,c(2)+1,c(3); c(1),c(2)+1,c(3); c(1)+1,c(2)+1,c(3);
                    c(1)-1,c(2)+1,c(3)-1; c(1),c(2)+1,c(3)-1; c(1)+1,c(2)+1,c(3)-1;
                    
                    c(1)-1,c(2),c(3)+1; c(1),c(2),c(3)+1; c(1)+1,c(2),c(3)+1;       
                    c(1)-1,c(2),c(3);                     c(1)+1,c(2),c(3);         
                    c(1)-1,c(2),c(3)-1; c(1),c(2),c(3)-1; c(1)+1,c(2),c(3)-1;       
                    
                    c(1)-1,c(2)-1,c(3)+1; c(1),c(2)-1,c(3)+1; c(1)+1,c(2)-1,c(3)+1;
                    c(1)-1,c(2)-1,c(3); c(1),c(2)-1,c(3); c(1)+1,c(2)-1,c(3);
                    c(1)-1,c(2)-1,c(3)-1; c(1),c(2)-1,c(3)-1; c(1)+1,c(2)-1,c(3)-1];
```

Segmentation get round over every adjacent area, the condition for segmentation is the maximum set intensity that the pixel tolerates and spreads further, otherwise it does not take it into account and goes backwards and continues the algorithm until the last pixel is found in the segmentation condition. The beginning of the segmentation stage is to set the starting point, the condition for its setting is to know the location of the pulmonary trunk on the CT image. A loop of segmentation propagation:

```
      while (~isempty(kolejka))                
        c=kolejka(1,:,:);                       
        kolejka=kolejka(2:size(kolejka,1),:,:); 
        if (~maska(c(1),c(2),c(3)))                 
            maska(c(1),c(2),c(3))=true;             
            if (abs(Jd(c(1),c(2),c(3))-Jsr)<=max_dJ) 
                Jw(c(1),c(2),c(3))=true;          
                sasiedzi=Fun_neighbors(c,x,y,z,sasiedztwo);    
                kolejka=[   kolejka;
                 sasiedzi];      
                             if (kryterium==2)
                    Jsr=(l_pix*Jsr+Jd(c(1),c(2),c(3)))/(l_pix+1) 
                    licz=licz+1
                end   
             l_pix=l_pix+1;                         
            end
        end
      end
      
 ```

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex4.png">
</p>

# Visualisation

For 3D visualization, the built-in Matlab function was used to visualize three-dimensional images. Description of functions from the Matlab documentation:
- ```fv = isosurface(X,Y,Z,V,isovalue)``` -  computes isosurface data from the volume data V at the isosurface value specified in isovalue. That is, the isosurface connects points that have the specified value much the way contour lines connect points of equal elevation.

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex5.png">
</p

# Aplication and use of the program

1. Download a folder with chest CT images. In my repository added a sample CT images (https://github.com/Marcin3232/App_for_lungs_reconstruction/tree/master/PhotoLungs).
2. Starting the application. The applications can be downloaded as an .exe file, if we do not have a Matlab, also if we want, we can download the working version of Application.mlapp.

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex6.png">
</p>

3. After opening the application, we have the option of choosing a folder, where we add this folder

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex7.png">
</p>

4. At this stage, we can view photos, we cut out photos that are outside the outline of the lungs.

<p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex8.png">
</p>

5. In the next stage, we move on to lung segmentation. We choose the thresholding range.

 <p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex9.png">
</p> 

6. In the next step, bronchial segmentation takes place. Define the segmentation threshold as in Step 2. Then select the row, column and tolerances for the algorithm

 <p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex10.png">
</p> 

7. The final step is segmentation of the pulmonary trunk. The intensity difference should be selected, after which the segmentation of growth will propagate. This step can be skipped and the result of the program is the reconstruction of the bronchial tree.


8. Finally, we press "Generuj" button, where the 3D visualization takes place.

 <p align="center">
  <img width="460" height="300" src="https://github.com/Marcin3232/App_for_lungs_reconstruction/ImageToReadme/ex1.png">
</p> 

# Summary

# Autors
Marcin Opiołka(https://github.com/Marcin3232), Tomasz Cieśliński (https://github.com/tomacie861), Michał Orlof
