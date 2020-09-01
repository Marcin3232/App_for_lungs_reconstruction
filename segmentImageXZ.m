function [BW,maskedImage] = segmentImage(X)
% Adjust data to span data range.
X = imadjust(X);
% Threshold image - manual threshold
BW = X > -5783;
% Invert mask
BW = imcomplement(BW);
% Clear borders
BW = imclearborder(BW);
% Erode mask with rectangle
dimensions = [3 3];
se = strel('rectangle', dimensions);
BW = imerode(BW, se);
% Dilate mask with rectangle
dimensions = [3 3];
se = strel('rectangle', dimensions);
BW = imdilate(BW, se);
% Dilate mask with square
width = 3;
se = strel('square', width);
BW = imdilate(BW, se);
% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end
