# App_for_lungs_reconstruction

The aim of the project is to reconstruct the 3D lung tree from cross-sectional photos of the chest, using the Matlab environment and image processing methods such as image segmentation. It is required that the photos are the same size and arranged in descending order in relation to the name.

# Application Examples

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

# Summary

# Autors
Marcin Opiołka(https://github.com/Marcin3232), Tomasz Cieśliński (https://github.com/tomacie861), Michał Orlof
