function [J2disp]=Fun_dispseed(J,seed,Jmax)
%% LABORATORIUM PRZETWARZANIA OBRAZÓW
%% Pawe³ Badura 2009
%% 
%% Funkcja wyœwietlaj¹ca obraz J z na³o¿onym punktem (w kolorze)

% Zielony krzy¿yk
shifts_small=[              -2  0;
                            -1  0;
    0   -2;     0   -1;     0   0;      0   1;      0   2;
                            1   0;
                            2   0];
shifts_big=[                                        -4  0;
                                                    -3  0;
                                                    -2  0;
                                                    -1  0;
    0   -4;     0   -3;     0   -2;     0   -1;     0   0;      0   1;      0   2;      0   3;      0   4;
                                                    1   0;
                                                    2   0;
                                                    3   0;
                                                    4   0];
[w,k]=size(J);
if (w<400)  shifts=shifts_small;    else    shifts=shifts_big;  end
% Indeksy punktów krzy¿yka
inds=ones(size(shifts,1),1)*seed + shifts;  inds=sub2ind([w k],inds(:,1),inds(:,2));
% Obraz RGB
J(inds)=0;      J2disp(:,:,1)=J;    J2disp(:,:,3)=J;
J(inds)=Jmax;    J2disp(:,:,2)=J;       % by WW