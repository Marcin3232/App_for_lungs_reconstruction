function [BW,maskedImage] = segmentBranchos(X,T,row,column,tolerance)
% Dopasowanie danych do zakresu macierzy wejsciowej X
X = imadjust(X);
% BW-->obraz progowany, Twartość progowania
BW = X > T  ;                                            
% Wypełnienie-- Flood fill
% uzycie tego ma na celu usuniecie konturow obrysu pluc
addedRegion = grayconnected(X, row, column, tolerance);
BW = BW | addedRegion;
% usuniecie granic, wypełnienie zlalo sie z konturami 
%usuniecie granic powoduje usuniecie kontur pluc
BW = imclearborder(BW);
%Utworzenie maski
maskedImage = X;
maskedImage(~BW) = 0;
end

