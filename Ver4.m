%%
clc;
clear;
close all;
%%
%wybor folderu z zdjeciami
dname=uigetdir('D:/Projekty_w_Realizacji/Studia/POM/POM_obrazy');
%%polaczenie wszystkich zdjec z folderu w calosc
%obraz startowy --->
obrazek=dicomread([dname,'\IMG00001.dcm']);
%użycie petli w celu sklejenia i wyboru zdjec
for i=2:700
 m=num2str(i);
 try
    if(i<10)       
 x=dicomread([dname,'\IMG0000',m,'.dcm']); 
 obraz=cat(3,obrazek,x); %cat łaczenie tablicy w macierz 3 wymiarow
 obrazek=+obraz; 
    end
 if(i<100)
     x=dicomread([dname,'\IMG000',m,'.dcm']);  
 obraz=cat(3,obraz,x);
 else   
          x=dicomread([dname,'\IMG00',m,'.dcm']); 
 obraz=cat(3,obraz,x);
 end
 catch
 end
end
%%
%przeskalowanie obrazu
%%
V=im2single(int16(obraz));
%% Wysegmentowanie pluc na kazdej warstwie XY
    XY=obraz(:,:,12);
    t=17990; %parametr do edycji/ progowanie i utworzenie maski 
             %dla piksela o wiekszym lub mnieszyj progu -->t
    first=segmentImageXY(XY,t); %obraz poczatkowy
%preprocessing dla kolejnych warstw
for i=12:1:700  
    try
    XY=obraz(:,:,i);
    XYmask=segmentImageXY(XY,t);
    JY=int16(XYmask);
    obY=XY.*JY;
    maska3D=cat(3,first,obY); 
    first=+maska3D;
    catch
    end
end
%%             
%Parametr
t2=16253;     %                  
row = 85;              
column = 80;
tolerance = 3.276750e+03;

% z odizolowanych pluc wyszukujemy oskrzela
rka=first(:,:,1); %warstwa startowa
second=segmentBranchos(rka,t2,row,column,tolerance); %funkcja segmentBranchos szukamy oskrzel i 
                             %nakładamy maske 
for i=1:1:700
  try
    XY=first(:,:,i);
    XYmask=segmentBranchos(XY,t2,row,column,tolerance);
    JY=int16(XYmask);
    obY=XY.*JY;
    maska3D=cat(3,second,obY); 
    second=+maska3D;
  catch
  end
end
%%


%% Segmentacja z zajec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XY=first(:,:,36);
J=im2uint8(obraz);
Jd=double(obraz);           
[x,y,z]=size(Jd);
Jmin=min(min(Jd));   
Jmax=max(max(Jd));     
%%
 imtool(XY,[])
 %%
 figure()
 imshow(XY,[])
 [xi(1),yi(1)] = getpts;
 close
%%
% Rozrost obszaru kod z ćwiczen laboratoryjnym POM lab3
s=[ceil(xi) ceil(yi) 36];
%s=[240 240 36];
%%%%%%%%%%%%%%%%%%%%%
max_dJ=100; %roznica intensywnosci rozchodzenia się rozrostu
sasiedztwo=26; 
%%%%%%%%%%%%%%%%%%%%%%%%%
kryterium=1;
    Jsr2disp=[3 200];           % wektor srednich intensywnosci
    l_pix=0;                    % licznik pikseli obiektu
    Jw=false(x,y,z);              % binarny obraz wynikowy
    maska=false(x,y,z);           % pomocnicza macierz informujÄ…ca czy juĹĽ sprawdzono dany piksel
    kolejka=s;                  % wstawienie do kolejki punktu startowego
    Jsr=Jd(s(1),s(2),s(3));
    licz=0;
 %%%%%%%%%%%%%%%%%%%%%%%%%
      while (~isempty(kolejka))                 % petla glołwna (max. 1s)
        c=kolejka(1,:,:);                         % punkt c ze szczytu kolejki do analizy
        kolejka=kolejka(2:size(kolejka,1),:,:);   % usuniecie c z kolejki
        if (~maska(c(1),c(2),c(3)))                  % czy punkt nie byl‚ jeszcze analizowany?
            maska(c(1),c(2),c(3))=true;              % odznaczenie punktu c w masce, ...
            if (abs(Jd(c(1),c(2),c(3))-Jsr)<=max_dJ) % czy kryterium wlaczenia jest speĹ‚nione?
                Jw(c(1),c(2),c(3))=true;             % wlaczenie punktu c do obiektu
                sasiedzi=Fun_neighbors(c,x,y,z,sasiedztwo);       % wyznaczenie indeksow sasiadow punktu c
                kolejka=[   kolejka;
                 sasiedzi];         % wstawienie sasiadow do kolejki
                             if (kryterium==2)
                    Jsr=(l_pix*Jsr+Jd(c(1),c(2),c(3)))/(l_pix+1) 
%                     if(licz==15000)
%                         break
%                     end
                    licz=licz+1
                    % aktualizacja średniej intensywności
                     % dopisanie do wektora średnich intensywności
                end   
             l_pix=l_pix+1;                  % inkrementacja licznika pikseli
                
            end

        end
      end
%%
pien=Jw(:,:,1);
for i=1:1:700
  try
    XY=obraz(:,:,i);
    XYmask=Jw(:,:,i);
    JY=int16(XYmask);
    obY=XY.*JY;
    maska3D=cat(3,Jw,obY); 
    pien=+maska3D;
  catch
  end
end
%FORMATOWANIE
%%
rka=second(:,:,1); 
full=second(:,:,1);
for i=1:1:700
  try
    XY=second(:,:,i);
    XYmask=pien(:,:,i);
    obY=JY+XYmask;
     maska3D=cat(3,full,obY); 
    full=+maska3D;
  catch
  end
end
%%
nowy2=im2single(int16(pien));
     
%%
%obrot
nowy2=flip(nowy2,3);
second=flip(second,3);
%%
%Wizualizacja oskrzeli
figure;
p = patch(isosurface(double(nowy2)));
p.FaceColor = 'red';
p.EdgeColor = 'none';
 hold on
 p = patch(isosurface(double(second)));
 p.FaceColor = 'blue';
 p.EdgeColor = 'none';
daspect([1 1 1/2]); %stosunek dlugosci osi x y z
camlight; 
axis vis3d
lighting gouraud
%lighting flat
%lighting none
%%
