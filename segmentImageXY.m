function [BW,maskedImage] = segmentImage(X,T)
% Dopasowanie danych do zakresu macierzy wejsciowej X
% okno intensywnosci
X = imadjust(X);
% BW-->obraz progowany, Twartość progowania
BW = X > T;
% Odwrocenie maski
BW = imcomplement(BW);
%usuniecie granic, obramowan
BW = imclearborder(BW);
% Morfologia --> Wykorzystanie erozji
radius = 3; 
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se); %
% wykorzystanie dylatacji w celu uwypuklenia dziur powstalych
%po erozji
radius = 3;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imdilate(BW, se);
% Utworzenia maski
maskedImage = X;
maskedImage(~BW) = 0;
end


